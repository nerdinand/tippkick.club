# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_14_052658) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "game_id", null: false
    t.integer "home_team_score"
    t.integer "guest_team_score"
    t.integer "home_team_score_points"
    t.integer "guest_team_score_points"
    t.integer "result_points"
    t.integer "perfect_bet_bonus_points"
    t.integer "total_points"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_bets_on_game_id"
    t.index ["user_id", "game_id"], name: "index_bets_on_user_id_and_game_id", unique: true
    t.index ["user_id"], name: "index_bets_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "uefa_game_id", null: false
    t.string "venue", null: false
    t.string "tournament_phase", null: false
    t.string "home_team_name"
    t.string "guest_team_name"
    t.integer "home_team_score", default: 0, null: false
    t.integer "guest_team_score", default: 0, null: false
    t.datetime "kickoff_at", null: false
    t.datetime "final_whistle_at"
    t.integer "max_total_points"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tournament_phase", "home_team_name", "guest_team_name"], name: "index_phase_home_guest", unique: true
    t.index ["uefa_game_id"], name: "index_games_on_uefa_game_id", unique: true
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "team_id", null: false
    t.boolean "coach", default: false, null: false
    t.integer "ranking_position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_memberships_on_team_id"
    t.index ["user_id", "team_id"], name: "index_memberships_on_user_id_and_team_id", unique: true
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.string "tippkick_id", null: false
    t.string "invitation_token", null: false
    t.integer "members_count", default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_teams_on_name", unique: true
    t.index ["tippkick_id"], name: "index_teams_on_tippkick_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "tippkick_id", null: false
    t.string "nickname", null: false
    t.integer "total_points", default: 0, null: false
    t.string "rooting_for_team"
    t.string "locale", default: "en", null: false
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "titles", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["nickname"], name: "index_users_on_nickname", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["tippkick_id"], name: "index_users_on_tippkick_id", unique: true
  end

  add_foreign_key "memberships", "teams"
  add_foreign_key "memberships", "users"
end
