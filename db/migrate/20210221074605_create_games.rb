class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.string :venue, null: false
      t.string :tournament_phase, null: false
      t.string :home_team_name, null: false
      t.string :guest_team_name, null: false
      t.integer :home_team_score, null: false, default: 0
      t.integer :guest_team_score, null: false, default: 0
      t.datetime :kickoff_at, null: false
      t.datetime :final_whistle_at, null: true

      t.index %i[tournament_phase home_team_name guest_team_name],
              unique: true,
              name: 'index_phase_home_guest'
      t.timestamps
    end
  end
end