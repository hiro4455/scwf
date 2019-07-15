# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_07_15_080936) do

  create_table "form_masters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "form_id"
    t.string "column_type"
    t.boolean "required"
    t.integer "display_order"
    t.string "metadata"
    t.string "name"
    t.string "desc"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "forms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "request_id"
    t.string "name"
    t.string "column_type"
    t.string "desc"
    t.boolean "required"
    t.string "value", limit: 1024
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_forms_on_request_id"
  end

  create_table "requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "status"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "workflow_id"
    t.string "name"
    t.integer "current_step"
    t.index ["user_id"], name: "index_requests_on_user_id"
    t.index ["workflow_id"], name: "index_requests_on_workflow_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "mail"
    t.string "kubun"
    t.string "jigyoubu"
    t.string "bumon"
    t.string "ka"
    t.string "job_class"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest", null: false
    t.string "remember_token"
  end

  create_table "workflows", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "request_id"
    t.bigint "user_id"
    t.boolean "approved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "required"
    t.integer "flow_step"
    t.index ["request_id"], name: "index_workflows_on_request_id"
    t.index ["user_id"], name: "index_workflows_on_user_id"
  end

  add_foreign_key "forms", "requests"
  add_foreign_key "requests", "users"
  add_foreign_key "workflows", "requests"
end
