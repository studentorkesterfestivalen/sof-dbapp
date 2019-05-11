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

ActiveRecord::Schema.define(version: 20190510195951) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_funkis_shift_limits", force: :cascade do |t|
    t.integer  "active_limit", default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "amount_constraints", force: :cascade do |t|
    t.integer  "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "amount_constraints_products", id: false, force: :cascade do |t|
    t.integer "product_id",           null: false
    t.integer "amount_constraint_id", null: false
    t.index ["amount_constraint_id"], name: "index_amount_constraints_products_on_amount_constraint_id", using: :btree
    t.index ["product_id"], name: "index_amount_constraints_products_on_product_id", using: :btree
  end

  create_table "available_articles", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "price"
    t.string   "data_name"
    t.text     "data_description"
    t.boolean  "orchestra_only"
    t.boolean  "enabled"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "base_products", force: :cascade do |t|
    t.string   "name",                                       null: false
    t.text     "description",                                null: false
    t.integer  "cost"
    t.bigint   "required_permissions",       default: 0,     null: false
    t.boolean  "enabled",                    default: true,  null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.bigint   "required_group_permissions", default: 0,     null: false
    t.boolean  "giftable",                   default: false, null: false
    t.integer  "purchase_limit",             default: 0,     null: false
    t.boolean  "has_image",                  default: false, null: false
    t.string   "image_path",                 default: "",    null: false
    t.string   "name_english"
    t.string   "description_english"
  end

  create_table "cart_items", force: :cascade do |t|
    t.integer  "cart_id"
    t.integer  "product_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "amount",     default: 0
    t.index ["cart_id"], name: "index_cart_items_on_cart_id", using: :btree
  end

  create_table "carts", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.datetime "valid_through"
    t.integer  "discount_code_id"
    t.index ["user_id"], name: "index_carts_on_user_id", using: :btree
  end

  create_table "case_corteges", force: :cascade do |t|
    t.string   "education",                             null: false
    t.string   "contact_phone",                         null: false
    t.integer  "case_cortege_type",                     null: false
    t.string   "group_name",                            null: false
    t.text     "motivation",                            null: false
    t.boolean  "approved",          default: false,     null: false
    t.string   "status",            default: "pending", null: false
    t.integer  "user_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.index ["user_id"], name: "index_case_corteges_on_user_id", using: :btree
  end

  create_table "cortege_memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "cortege_id"
    t.integer  "case_cortege_id"
    t.index ["case_cortege_id"], name: "index_cortege_memberships_on_case_cortege_id", using: :btree
    t.index ["cortege_id"], name: "index_cortege_memberships_on_cortege_id", using: :btree
    t.index ["user_id"], name: "index_cortege_memberships_on_user_id", using: :btree
  end

  create_table "corteges", force: :cascade do |t|
    t.string   "name",                limit: 30,                     null: false
    t.string   "student_association"
    t.integer  "participant_count",              default: 0,         null: false
    t.integer  "cortege_type",                                       null: false
    t.string   "contact_phone",                                      null: false
    t.text     "idea",                                               null: false
    t.text     "comments"
    t.boolean  "approved",                       default: false,     null: false
    t.string   "status",                         default: "pending", null: false
    t.integer  "user_id"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.boolean  "paid",                           default: false,     null: false
    t.index ["user_id"], name: "index_corteges_on_user_id", using: :btree
  end

  create_table "discount_codes", force: :cascade do |t|
    t.integer  "discount"
    t.integer  "uses"
    t.string   "code",       null: false
    t.integer  "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_discount_codes_on_product_id", using: :btree
  end

  create_table "faq_groups", force: :cascade do |t|
    t.string   "name",                    null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "name_eng",   default: "", null: false
  end

  create_table "faqs", force: :cascade do |t|
    t.string   "question",                  null: false
    t.text     "answer",                    null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "faq_group_id"
    t.string   "question_eng", default: "", null: false
    t.text     "answer_eng",   default: "", null: false
    t.index ["faq_group_id"], name: "index_faqs_on_faq_group_id", using: :btree
  end

  create_table "funkis_applications", force: :cascade do |t|
    t.string   "ssn",                             null: false
    t.string   "phone",                           null: false
    t.string   "tshirt_size",                     null: false
    t.text     "allergies",       default: "",    null: false
    t.boolean  "drivers_license", default: false, null: false
    t.integer  "presale_choice",  default: 0,     null: false
    t.datetime "terms_agreed_at"
    t.integer  "user_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["user_id"], name: "index_funkis_applications_on_user_id", using: :btree
  end

  create_table "funkis_categories", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "funkis_name", null: false
    t.string   "description", null: false
    t.string   "points",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "funkis_shift_applications", force: :cascade do |t|
    t.integer  "funkis_application_id"
    t.integer  "funkis_shift_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["funkis_application_id"], name: "index_funkis_shift_applications_on_funkis_application_id", using: :btree
    t.index ["funkis_shift_id"], name: "index_funkis_shift_applications_on_funkis_shift_id", using: :btree
  end

  create_table "funkis_shifts", force: :cascade do |t|
    t.string   "day",                             null: false
    t.string   "time",                            null: false
    t.integer  "points"
    t.integer  "funkis_category_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "red_limit",          default: 0,  null: false
    t.integer  "yellow_limit",       default: 0,  null: false
    t.integer  "green_limit",        default: 0,  null: false
    t.string   "date",               default: "", null: false
    t.index ["funkis_category_id"], name: "index_funkis_shifts_on_funkis_category_id", using: :btree
  end

  create_table "lineups", force: :cascade do |t|
    t.string   "name",        null: false
    t.text     "description", null: false
    t.string   "image",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order"
    t.boolean  "orchestra"
    t.boolean  "ballet"
    t.boolean  "cortege"
  end

  create_table "menu_items", force: :cascade do |t|
    t.string   "title",                               null: false
    t.boolean  "active",               default: true, null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "menu_item_id"
    t.string   "category"
    t.integer  "required_permissions", default: 0,    null: false
    t.boolean  "display_empty",        default: true, null: false
    t.string   "href",                 default: "#",  null: false
    t.datetime "enabled_from"
    t.datetime "disabled_from"
    t.index ["menu_item_id"], name: "index_menu_items_on_menu_item_id", using: :btree
  end

  create_table "orchestra_articles", force: :cascade do |t|
    t.integer  "kind"
    t.integer  "data"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "orchestra_signup_id"
    t.string   "size"
    t.index ["orchestra_signup_id"], name: "index_orchestra_articles_on_orchestra_signup_id", using: :btree
  end

  create_table "orchestra_food_tickets", force: :cascade do |t|
    t.integer  "kind"
    t.string   "diet"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "orchestra_signup_id"
    t.index ["orchestra_signup_id"], name: "index_orchestra_food_tickets_on_orchestra_signup_id", using: :btree
  end

  create_table "orchestra_signups", force: :cascade do |t|
    t.boolean  "dormitory"
    t.boolean  "active_member"
    t.boolean  "consecutive_10"
    t.boolean  "attended_25"
    t.integer  "instrument_size"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "orchestra_id"
    t.integer  "user_id"
    t.text     "other_performances"
    t.boolean  "is_late_registration", default: false, null: false
    t.integer  "orchestra_role"
    t.integer  "arrival_date"
    t.index ["orchestra_id"], name: "index_orchestra_signups_on_orchestra_id", using: :btree
    t.index ["user_id"], name: "index_orchestra_signups_on_user_id", using: :btree
  end

  create_table "orchestra_tickets", force: :cascade do |t|
    t.integer  "kind"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "orchestra_signup_id"
    t.index ["orchestra_signup_id"], name: "index_orchestra_tickets_on_orchestra_signup_id", using: :btree
  end

  create_table "orchestras", force: :cascade do |t|
    t.string   "name",                           null: false
    t.string   "code",                           null: false
    t.boolean  "allow_signup",   default: true
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "user_id"
    t.boolean  "dormitory",      default: false, null: false
    t.integer  "orchestra_type", default: 0,     null: false
    t.string   "email"
    t.integer  "arrival_date"
    t.index ["user_id"], name: "index_orchestras_on_user_id", using: :btree
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "order_id"
    t.integer  "product_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "owner_id"
    t.integer  "gifted_by_id"
    t.integer  "cost",         default: 0,     null: false
    t.integer  "collected",    default: 0,     null: false
    t.datetime "collected_at"
    t.integer  "amount"
    t.boolean  "refunded",     default: false
    t.index ["gifted_by_id"], name: "index_order_items_on_gifted_by_id", using: :btree
    t.index ["order_id"], name: "index_order_items_on_order_id", using: :btree
    t.index ["owner_id"], name: "index_order_items_on_owner_id", using: :btree
    t.index ["user_id"], name: "index_order_items_on_user_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.string   "payment_method",                   null: false
    t.string   "payment_data"
    t.integer  "user_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "rebate",           default: 0,     null: false
    t.integer  "funkis_rebate",    default: 0,     null: false
    t.boolean  "receipt_sent",     default: false, null: false
    t.string   "receipt_url"
    t.integer  "discount_code_id"
    t.index ["user_id"], name: "index_orders_on_user_id", using: :btree
  end

  create_table "pages", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "category",     default: "index", null: false
    t.string   "page",         default: "",      null: false
    t.string   "header",       default: "",      null: false
    t.text     "content",      default: "",      null: false
    t.boolean  "show_in_menu", default: false,   null: false
    t.string   "image"
  end

  create_table "products", force: :cascade do |t|
    t.string   "kind"
    t.integer  "cost"
    t.boolean  "enabled",           default: true, null: false
    t.integer  "base_product_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "max_num_available", default: 0,    null: false
    t.integer  "purchase_limit",    default: 0,    null: false
    t.integer  "given_out_amount",  default: 0
    t.string   "kind_english"
    t.integer  "separately_sold",   default: 0
    t.index ["base_product_id"], name: "index_products_on_base_product_id", using: :btree
  end

  create_table "special_diets", force: :cascade do |t|
    t.string   "name",                                null: false
    t.boolean  "is_default",          default: false, null: false
    t.integer  "orchestra_signup_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["orchestra_signup_id"], name: "index_special_diets_on_orchestra_signup_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider",               default: "email",                     null: false
    t.string   "uid",                    default: "",                          null: false
    t.string   "encrypted_password",     default: "",                          null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                           null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "email"
    t.text     "tokens"
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.bigint   "admin_permissions",      default: 0,                           null: false
    t.string   "union"
    t.datetime "union_valid_thru",       default: '2017-03-22 13:04:50',       null: false
    t.string   "display_name"
    t.bigint   "usergroup",              default: 0,                           null: false
    t.integer  "rebate_balance",         default: 0
    t.boolean  "rebate_given",           default: false,                       null: false
    t.boolean  "allow_password_change",  default: false,                       null: false
    t.uuid     "uuid",                   default: -> { "uuid_generate_v4()" }, null: false
    t.string   "liu_card_number"
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  end

  add_foreign_key "discount_codes", "products"
end
