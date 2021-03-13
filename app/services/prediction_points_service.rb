# rubocop:disable Metrics/ClassLength
class PredictionPointsService
  def call!
    Prediction.transaction do
      execute reset_prediction_points_sql
      execute update_prediction_points_sql
      execute update_user_total_points_sql
    end
  end

  private

  def execute(statement)
    ApplicationRecord.connection.execute(statement)
  end

  def reset_prediction_points_sql
    <<~SQL.squish
      UPDATE predictions
         SET home_team_score_points = NULL
           , guest_team_score_points = NULL
           , result_points = NULL
           , perfect_prediction_bonus_points = NULL
           , total_points = NULL
    SQL
  end

  def update_prediction_points_sql
    <<~SQL.squish
      WITH games_results AS (
        SELECT id               AS game_id
             , home_team_score  AS actual_home_team_score
             , guest_team_score AS actual_guest_team_score
             , CASE
                 WHEN home_team_score > guest_team_score THEN 'HOMEWINS'
                 WHEN home_team_score < guest_team_score THEN 'GUESTWINS'
               ELSE 'DRAW'
               END              AS actual_result
          FROM games
         WHERE final_whistle_at IS NOT NULL
      )

      , predicted_games AS (
        SELECT *
          FROM predictions
         WHERE home_team_score IS NOT NULL
           AND guest_team_score IS NOT NULL
      )

      , predictions_results AS (
        SELECT id                 AS prediction_id
             , game_id            AS game_id
             , home_team_score    AS predicted_home_team_score
             , guest_team_score   AS predicted_guest_team_score
             , CASE
                 WHEN home_team_score > guest_team_score THEN 'HOMEWINS'
                 WHEN home_team_score < guest_team_score THEN 'GUESTWINS'
                 ELSE 'DRAW'
               END                AS predicted_result
          FROM predicted_games
      )

      , with_points AS (
        SELECT gr.game_id
             , gr.actual_home_team_score
             , gr.actual_guest_team_score
             , gr.actual_result
             , pr.prediction_id
             , pr.predicted_home_team_score
             , pr.predicted_guest_team_score
             , pr.predicted_result
             , CASE
                 WHEN gr.actual_home_team_score = pr.predicted_home_team_score THEN gr.actual_home_team_score
                 ELSE 0
               END      AS home_team_score_points
             , CASE
                 WHEN gr.actual_guest_team_score = pr.predicted_guest_team_score THEN gr.actual_guest_team_score
                 ELSE 0
               END      AS guest_team_score_points
             , CASE
                 WHEN gr.actual_result = pr.predicted_result THEN 3
                 ELSE 0
               END      AS result_points
             , CASE
                 WHEN gr.actual_home_team_score = pr.predicted_home_team_score
                  AND gr.actual_guest_team_score = pr.predicted_guest_team_score THEN 2
                 ELSE 0
               END      AS perfect_prediction_bonus_points
          FROM games_results gr
         INNER JOIN predictions_results pr ON pr.game_id = gr.game_id
      )

      UPDATE predictions
         SET home_team_score_points          = with_points.home_team_score_points
           , guest_team_score_points         = with_points.guest_team_score_points
           , result_points                   = with_points.result_points
           , perfect_prediction_bonus_points = with_points.perfect_prediction_bonus_points
           , total_points                    = with_points.home_team_score_points +
                                               with_points.guest_team_score_points +
                                               with_points.result_points +
                                               with_points.perfect_prediction_bonus_points
        FROM with_points
       WHERE with_points.prediction_id = predictions.id
    SQL
  end

  def update_user_total_points_sql
    <<~SQL.squish
      WITH user_total_points AS (
        SELECT user_id              AS user_id
             , sum(total_points)    AS total_points
          FROM predictions
         GROUP BY user_id
      )
      UPDATE users
         SET total_points = user_total_points.total_points
        FROM user_total_points
       WHERE user_total_points.user_id = users.id
    SQL
  end
end
# rubocop:enable Metrics/ClassLength
