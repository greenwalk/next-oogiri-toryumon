# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_11_16_142031) do

  create_table "basin_fields", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "status", default: 0, comment: "お題ステータス"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "basin_oogiris", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "content", limit: 30, default: "", null: false, comment: "回答"
    t.bigint "user_id", null: false
    t.bigint "basin_field_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["basin_field_id"], name: "index_basin_oogiris_on_basin_field_id"
    t.index ["user_id"], name: "index_basin_oogiris_on_user_id"
  end

  create_table "basin_theme_adjectives", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "adjective_word", default: "", null: false, comment: "形容詞"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "basin_theme_nouns", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "noun_word", default: "", null: false, comment: "名詞"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "comment_likes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "comment_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["comment_id"], name: "index_comment_likes_on_comment_id"
    t.index ["user_id"], name: "index_comment_likes_on_user_id"
  end

  create_table "comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "oogiri_id", null: false
    t.string "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["oogiri_id"], name: "index_comments_on_oogiri_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "fields", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "text_theme", default: "", comment: "文字お題"
    t.integer "status", default: 0, comment: "お題ステータス"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "oogiris", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "content", limit: 200, null: false, comment: "回答"
    t.integer "point", default: 0, null: false, comment: "得点"
    t.integer "score", default: 0, null: false, comment: "スコア"
    t.integer "get_rank", default: 0, null: false, comment: "順位"
    t.bigint "user_id", null: false
    t.bigint "field_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["field_id"], name: "index_oogiris_on_field_id"
    t.index ["user_id"], name: "index_oogiris_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", null: false
    t.integer "rate", default: 1500, null: false
    t.integer "max_rate", default: 1500, null: false
    t.string "rate_class", default: "<i class='fa-solid fa-seedling' style='color: #66CC00;'></i>", null: false
    t.date "oogiri_start", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "vote_point", null: false, comment: "点数"
    t.bigint "user_id", null: false
    t.bigint "oogiri_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "field_id", null: false
    t.integer "change_num", default: 0, null: false
    t.index ["field_id"], name: "index_votes_on_field_id"
    t.index ["oogiri_id"], name: "index_votes_on_oogiri_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "basin_oogiris", "basin_fields"
  add_foreign_key "basin_oogiris", "users"
  add_foreign_key "comment_likes", "comments"
  add_foreign_key "comment_likes", "users"
  add_foreign_key "comments", "oogiris"
  add_foreign_key "comments", "users"
  add_foreign_key "oogiris", "fields"
  add_foreign_key "oogiris", "users"
  add_foreign_key "votes", "oogiris"
  add_foreign_key "votes", "users"
end
