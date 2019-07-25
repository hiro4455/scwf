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

ActiveRecord::Schema.define(version: 2019_07_25_194506) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

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
    t.bigint "workflow_master_id"
    t.string "behaviour"
    t.index ["workflow_master_id"], name: "index_form_masters_on_workflow_master_id"
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

  create_table "organizations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "level"
    t.integer "parent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "status"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "workflow_id"
    t.string "name"
    t.integer "current_step"
    t.bigint "workflow_master_id"
    t.integer "approving_step"
    t.boolean "draft"
    t.boolean "in_progress"
    t.index ["in_progress"], name: "index_requests_on_in_progress"
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

  create_table "workflow_masters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "approving_step"
  end

  create_table "workflow_step_masters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "workflow_master_id"
    t.string "name"
    t.integer "flow_step"
    t.string "approve_type"
    t.boolean "editable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workflow_master_id"], name: "index_workflow_step_masters_on_workflow_master_id"
  end

  create_table "workflow_step_templates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "workflow_master_id"
    t.integer "template_id"
    t.integer "flow_step"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_workflow_step_templates_on_template_id"
    t.index ["user_id"], name: "index_workflow_step_templates_on_user_id"
    t.index ["workflow_master_id"], name: "index_workflow_step_templates_on_workflow_master_id"
  end

  create_table "workflows", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "request_id"
    t.bigint "user_id"
    t.boolean "approved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "required"
    t.integer "flow_step"
    t.string "comment"
    t.index ["request_id"], name: "index_workflows_on_request_id"
    t.index ["user_id"], name: "index_workflows_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "forms", "requests"
  add_foreign_key "requests", "users"
  add_foreign_key "workflow_step_masters", "workflow_masters"
  add_foreign_key "workflow_step_templates", "users"
  add_foreign_key "workflow_step_templates", "workflow_masters"
  add_foreign_key "workflows", "requests"
end
