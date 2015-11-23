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

ActiveRecord::Schema.define(:version => 20151123040122) do

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         :default => 0
    t.string   "comment"
    t.string   "remote_address"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], :name => "associated_index"
  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "commodities", :force => true do |t|
    t.string   "name",                  :limit => 50
    t.integer  "commodity_category_id"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.integer  "unit_id"
    t.string   "strength_dosage"
    t.string   "abbreviation"
    t.string   "quantity_per_packg"
    t.float    "pack_size"
    t.integer  "regimen_id"
    t.integer  "lab_test_id"
    t.integer  "position",                            :default => 0
  end

  add_index "commodities", ["commodity_category_id"], :name => "commodities_commodity_category_id_fk"
  add_index "commodities", ["lab_test_id"], :name => "index_commodities_on_lab_test_id"
  add_index "commodities", ["name"], :name => "index_commodities_on_name"
  add_index "commodities", ["position", "name"], :name => "index_commodities_on_position_and_name"
  add_index "commodities", ["position"], :name => "index_commodities_on_position"
  add_index "commodities", ["regimen_id"], :name => "index_commodities_on_regimen_id"
  add_index "commodities", ["unit_id"], :name => "commodities_unit_id_fk"

  create_table "commodity_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "com_type"
    t.integer  "pos",        :default => 0
  end

  add_index "commodity_categories", ["com_type"], :name => "index_commodity_categories_on_com_type"

  create_table "import_survs", :force => true do |t|
    t.string   "surv_type"
    t.string   "form"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "year"
    t.integer  "month"
  end

  add_index "import_survs", ["user_id"], :name => "import_survs_user_id_fk"

  create_table "lab_test_categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "lab_tests", :force => true do |t|
    t.string   "name"
    t.integer  "lab_test_category_id"
    t.integer  "unit_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "lab_tests", ["lab_test_category_id"], :name => "index_lab_tests_on_lab_test_category_id"
  add_index "lab_tests", ["unit_id"], :name => "index_lab_tests_on_unit_id"

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
    t.integer  "order_frequency"
    t.integer  "site_id"
    t.float    "pack_size",                                                       :default => 1.0
    t.integer  "system_suggestion"
    t.float    "suggestion_order"
  end

  add_index "order_lines", ["commodity_id"], :name => "index_order_lines_on_commodity_id"
  add_index "order_lines", ["order_id", "shipment_status", "completed_order"], :name => "shippable_index"
  add_index "order_lines", ["order_id"], :name => "index_order_lines_on_order_id"
  add_index "order_lines", ["site_id"], :name => "order_lines_site_id_fk"

  create_table "orders", :force => true do |t|
    t.integer  "site_id"
    t.boolean  "is_requisition_form"
    t.integer  "user_place_order_id"
    t.date     "order_date"
    t.integer  "user_data_entry_id"
    t.datetime "review_date"
    t.integer  "review_user_id"
    t.string   "status",                :limit => 15
    t.integer  "requisition_report_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.date     "date_submittion"
  end

  add_index "orders", ["requisition_report_id"], :name => "index_orders_on_requisition_report_id"
  add_index "orders", ["site_id"], :name => "index_orders_on_site_id"
  add_index "orders", ["status", "site_id"], :name => "index_orders_on_status_and_site_id"
  add_index "orders", ["status"], :name => "index_orders_on_status"
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

  create_table "regimen", :force => true do |t|
    t.string   "name"
    t.integer  "regimen_category_id"
    t.integer  "unit_id"
    t.string   "strength_dosage"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "regimen", ["regimen_category_id"], :name => "index_regimen_on_regimen_category_id"
  add_index "regimen", ["unit_id"], :name => "index_regimen_on_unit_id"

  create_table "regimen_categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "requisition_reports", :force => true do |t|
    t.string   "form"
    t.integer  "site_id"
    t.integer  "user_id"
    t.string   "status",     :default => "PENDING"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "requisition_reports", ["site_id"], :name => "requisition_reports_site_id_fk"
  add_index "requisition_reports", ["user_id"], :name => "requisition_reports_user_id_fk"

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
    t.string   "status",               :limit => 25
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
    t.datetime "lost_date",                          :default => '2015-11-16 04:07:55'
    t.float    "cost"
    t.integer  "carton"
    t.integer  "site_messages_count",                :default => 0
    t.float    "weight"
  end

  add_index "shipments", ["carton"], :name => "index_shipments_on_carton"
  add_index "shipments", ["consignment_number"], :name => "index_shipments_on_consignment_number"
  add_index "shipments", ["cost"], :name => "index_shipments_on_cost"
  add_index "shipments", ["status"], :name => "index_shipments_on_status"

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

  add_index "site_messages", ["shipment_id"], :name => "site_messages_shipment_id_fk"
  add_index "site_messages", ["site_id"], :name => "index_site_messages_on_site_id"

  create_table "sites", :force => true do |t|
    t.string   "name"
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
    t.string   "town"
    t.string   "region"
  end

  add_index "sites", ["province_id"], :name => "sites_province_id_fk"

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

  add_index "sms_logs", ["shipment_id"], :name => "sms_logs_shipment_id_fk"
  add_index "sms_logs", ["site_id"], :name => "sms_logs_site_id_fk"

  create_table "surv_site_commodities", :force => true do |t|
    t.integer  "surv_site_id"
    t.integer  "commodity_id"
    t.integer  "quantity",     :default => 0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "surv_site_commodities", ["commodity_id"], :name => "index_surv_site_commodities_on_commodity_id"
  add_index "surv_site_commodities", ["surv_site_id"], :name => "index_surv_site_commodities_on_surv_site_id"

  create_table "surv_sites", :force => true do |t|
    t.integer  "import_surv_id"
    t.integer  "site_id"
    t.integer  "month"
    t.integer  "year"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "surv_site_commodities_count", :default => 0
    t.string   "surv_type"
  end

  add_index "surv_sites", ["import_surv_id"], :name => "index_surv_sites_on_import_surv_id"
  add_index "surv_sites", ["site_id"], :name => "surv_sites_site_id_fk"

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
  add_index "users", ["site_id"], :name => "users_site_id_fk"
  add_index "users", ["user_name"], :name => "index_users_on_user_name", :unique => true

  add_foreign_key "commodities", "commodity_categories", name: "commodities_commodity_category_id_fk"
  add_foreign_key "commodities", "lab_tests", name: "commodities_lab_test_id_fk"
  add_foreign_key "commodities", "regimen", name: "commodities_regimen_id_fk"
  add_foreign_key "commodities", "units", name: "commodities_unit_id_fk"

  add_foreign_key "import_survs", "users", name: "import_survs_user_id_fk"

  add_foreign_key "lab_tests", "lab_test_categories", name: "lab_tests_lab_test_category_id_fk"
  add_foreign_key "lab_tests", "units", name: "lab_tests_unit_id_fk"

  add_foreign_key "order_lines", "commodities", name: "order_lines_commodity_id_fk"
  add_foreign_key "order_lines", "orders", name: "order_lines_order_id_fk"
  add_foreign_key "order_lines", "sites", name: "order_lines_site_id_fk"

  add_foreign_key "regimen", "regimen_categories", name: "regimen_regimen_category_id_fk"
  add_foreign_key "regimen", "units", name: "regimen_unit_id_fk"

  add_foreign_key "requisition_reports", "sites", name: "requisition_reports_site_id_fk"
  add_foreign_key "requisition_reports", "users", name: "requisition_reports_user_id_fk"

  add_foreign_key "site_messages", "shipments", name: "site_messages_shipment_id_fk"
  add_foreign_key "site_messages", "sites", name: "site_messages_site_id_fk"

  add_foreign_key "sites", "provinces", name: "sites_province_id_fk"

  add_foreign_key "sms_logs", "shipments", name: "sms_logs_shipment_id_fk"
  add_foreign_key "sms_logs", "sites", name: "sms_logs_site_id_fk"

  add_foreign_key "surv_site_commodities", "commodities", name: "surv_site_commodities_commodity_id_fk"
  add_foreign_key "surv_site_commodities", "surv_sites", name: "surv_site_commodities_surv_site_id_fk"

  add_foreign_key "surv_sites", "sites", name: "surv_sites_site_id_fk"

  add_foreign_key "users", "sites", name: "users_site_id_fk"

end
