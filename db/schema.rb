# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130926084556) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "commodities", :force => true do |t|
    t.string   "name"
    t.integer  "commodity_category_id"
    t.integer  "consumption_per_client_pack"
    t.integer  "consumption_per_client_unit"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "unit_id"
    t.string   "strength_dosage"
    t.string   "abbreviation"
    t.string   "quantity_per_packg"
  end

  create_table "commodity_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "com_type"
  end

  create_table "import_survs", :force => true do |t|
    t.string   "surv_type"
    t.string   "form"
    t.integer  "user_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "year"
    t.string   "month",      :limit => 20
  end

  create_table "order_lines", :force => true do |t|
    t.integer  "order_id"
    t.integer  "commodity_id"
    t.integer  "stock_on_hand"
    t.integer  "monthly_use"
    t.datetime "earliest_expiry"
    t.integer  "quantity_system_calculation"
    t.integer  "quantity_suggested"
    t.text     "user_data_entry_note"
    t.text     "user_reviewer_note"
    t.string   "status"
    t.datetime "created_at",                                                                         :null => false
    t.datetime "updated_at",                                                                         :null => false
    t.string   "arv_type"
    t.decimal  "site_suggestion",                  :precision => 10, :scale => 0
    t.decimal  "test_kit_waste_acceptable",        :precision => 10, :scale => 0
    t.integer  "number_of_client"
    t.decimal  "consumption_per_client_per_month", :precision => 10, :scale => 0
    t.boolean  "is_set",                                                          :default => false
    t.boolean  "shipment_status",                                                 :default => false
    t.integer  "completed_order",                                                 :default => 0
    t.float    "order_frequency"
    t.integer  "site_id"
  end

  add_index "order_lines", ["commodity_id"], :name => "index_order_lines_on_commodity_id"
  add_index "order_lines", ["order_id"], :name => "index_order_lines_on_order_id"

  create_table "orders", :force => true do |t|
    t.integer  "site_id"
    t.boolean  "is_requisition_form"
    t.integer  "user_place_order_id"
    t.date     "order_date"
    t.integer  "user_data_entry_id"
    t.datetime "review_date"
    t.integer  "review_user_id"
    t.string   "status"
    t.integer  "requisition_report_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.date     "date_submittion"
  end

  add_index "orders", ["requisition_report_id"], :name => "index_orders_on_requisition_report_id"
  add_index "orders", ["site_id"], :name => "index_orders_on_site_id"
  add_index "orders", ["user_data_entry_id"], :name => "index_orders_on_user_data_entry_id"
  add_index "orders", ["user_place_order_id"], :name => "index_orders_on_user_place_order_id"

  create_table "provinces", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "public_holidays", :force => true do |t|
    t.string   "name"
    t.date     "date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "requisition_reports", :force => true do |t|
    t.string   "form"
    t.integer  "site_id"
    t.integer  "user_id"
    t.string   "status",     :default => "PENDING"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.string   "name"
    t.string   "tip"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shipment_lines", :force => true do |t|
    t.integer  "shipment_id"
    t.integer  "quantity_suggested"
    t.integer  "quantity_issued"
    t.integer  "quantity_received"
    t.integer  "order_line_id"
    t.string   "remark"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "shipments", :force => true do |t|
    t.string   "consignment_number",   :limit => 20
    t.string   "status",               :limit => 20
    t.date     "shipment_date"
    t.datetime "received_date"
    t.integer  "user_id"
    t.integer  "site_id"
    t.integer  "order_id"
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
    t.integer  "sms_logs_count",                     :default => 0
    t.integer  "shipment_lines_count",               :default => 0
    t.datetime "last_notified_date"
    t.datetime "lost_date",                          :default => '2013-10-08 04:57:38'
    t.float    "cost"
    t.integer  "carton"
    t.integer  "site_messages_count",                :default => 0
  end

  create_table "site_messages", :force => true do |t|
    t.text     "message"
    t.integer  "site_id"
    t.string   "status"
    t.string   "consignment_number"
    t.string   "guid"
    t.string   "from_phone"
    t.integer  "error",              :default => 0
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "response_message"
    t.integer  "carton"
    t.integer  "shipment_id"
  end

  add_index "site_messages", ["site_id"], :name => "index_site_messages_on_site_id"

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.float    "lat"
    t.float    "lng"
    t.string   "service_type"
    t.float    "suggestion_order"
    t.integer  "order_frequency"
    t.integer  "number_of_deadline_sumission"
    t.date     "order_start_at"
    t.float    "test_kit_waste_acceptable"
    t.text     "address"
    t.string   "contact_name"
    t.string   "mobile"
    t.string   "land_line_number"
    t.string   "email"
    t.integer  "province_id"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "in_every"
    t.string   "duration_type"
    t.integer  "sms_alerted",                  :default => 0
    t.integer  "site_messages_count",          :default => 0
  end

  create_table "sms_logs", :force => true do |t|
    t.string   "message"
    t.integer  "shipment_id"
    t.integer  "site_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "to"
    t.string   "sms_type"
    t.string   "guid"
    t.string   "status"
  end

  create_table "surv_site_commodities", :force => true do |t|
    t.integer  "surv_site_id"
    t.integer  "commodity_id"
    t.integer  "quantity",     :default => 0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "surv_sites", :force => true do |t|
    t.integer  "import_surv_id"
    t.integer  "site_id"
    t.string   "month"
    t.integer  "year"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "surv_site_commodities_count", :default => 0
    t.string   "surv_type"
  end

  create_table "units", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "user_name",              :default => "", :null => false
    t.string   "phone_number",           :default => "", :null => false
    t.string   "display_name",           :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "site_id"
    t.string   "role"
  end

  add_index "users", ["phone_number"], :name => "index_users_on_phone_number", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["user_name"], :name => "index_users_on_user_name", :unique => true

end
