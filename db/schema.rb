# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100415090634) do

  create_table "account_receivables", :force => true do |t|
  end

  create_table "addresses", :force => true do |t|
    t.string  "post_office_box",  :limit => 50
    t.string  "extended_address", :limit => 50
    t.string  "street_address",   :limit => 50
    t.string  "locality",         :limit => 50
    t.string  "region",           :limit => 50
    t.string  "postal_code",      :limit => 50
    t.string  "country_name",     :limit => 50
    t.string  "type"
    t.integer "vcard_id"
    t.string  "address_type"
  end

  add_index "addresses", ["vcard_id"], :name => "addresses_vcard_id_index"

  create_table "bills", :force => true do |t|
    t.integer  "case_id"
    t.float    "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_storno"
    t.integer  "praxistar_rechnungs_id"
    t.integer  "praxistar_leistungsblatt_id"
  end

  add_index "bills", ["case_id"], :name => "index_bills_on_case_id"
  add_index "bills", ["praxistar_leistungsblatt_id"], :name => "index_bills_on_praxistar_leistungsblatt_id"
  add_index "bills", ["praxistar_rechnungs_id"], :name => "index_bills_on_praxistar_rechnungs_id"

  create_table "cases", :force => true do |t|
    t.integer  "examination_method_id"
    t.date     "examination_date"
    t.integer  "classification_id"
    t.string   "praxistar_eingangsnr",        :limit => 8
    t.integer  "patient_id"
    t.integer  "doctor_id"
    t.date     "entry_date"
    t.integer  "screener_id"
    t.integer  "insurance_id"
    t.string   "insurance_nr"
    t.integer  "praxistar_leistungsblatt_id"
    t.datetime "screened_at"
    t.datetime "result_report_printed_at"
    t.boolean  "needs_p16",                                :default => false
    t.text     "finding_text"
    t.text     "remarks"
    t.datetime "assigned_at"
    t.datetime "assigned_screener_id"
    t.integer  "intra_day_id"
    t.datetime "hpv_p16_prepared_at"
    t.integer  "hpv_p16_prepared_by"
    t.datetime "scheduled_at"
    t.integer  "scheduled_for"
    t.datetime "centrifuged_at"
    t.integer  "centrifuged_by"
    t.boolean  "needs_hpv",                                :default => false
    t.boolean  "needs_review",                             :default => false
    t.integer  "first_entry_by"
    t.datetime "first_entry_at"
    t.integer  "review_by"
    t.datetime "review_at"
    t.datetime "p16_notice_printed_at"
    t.datetime "email_sent_at"
  end

  add_index "cases", ["doctor_id"], :name => "cases_doctor_id_index"
  add_index "cases", ["insurance_id"], :name => "cases_insurance_id_index"
  add_index "cases", ["needs_p16"], :name => "index_cases_on_needs_p16"
  add_index "cases", ["patient_id"], :name => "cases_patient_id_index"
  add_index "cases", ["praxistar_eingangsnr"], :name => "cases_praxistar_eingangsnr_index", :unique => true
  add_index "cases", ["result_report_printed_at"], :name => "i1"
  add_index "cases", ["screened_at"], :name => "index_cases_on_screened_at"

  create_table "cases_finding_classes", :id => false, :force => true do |t|
    t.integer "case_id"
    t.integer "finding_class_id"
    t.integer "position"
  end

  add_index "cases_finding_classes", ["case_id", "finding_class_id"], :name => "cases_finding_classes_case_id_index", :unique => true

  create_table "cases_finding_classes_second", :id => false, :force => true do |t|
    t.integer "case_id"
    t.integer "finding_class_id"
  end

  create_table "cases_mailings", :id => false, :force => true do |t|
    t.integer "case_id"
    t.integer "mailing_id"
  end

  add_index "cases_mailings", ["case_id"], :name => "index_cases_mailings_on_case_id"
  add_index "cases_mailings", ["mailing_id"], :name => "index_cases_mailings_on_mailing_id"

  create_table "cases_second", :force => true do |t|
    t.integer "examination_method_id"
    t.date    "examination_date"
    t.integer "classification_id"
    t.string  "praxistar_eingangsnr",  :limit => 8
  end

  create_table "classification_groups", :force => true do |t|
    t.string  "title"
    t.integer "position"
  end

  create_table "classification_tarmed_leistungens", :force => true do |t|
    t.integer "classification_id"
    t.string  "tarmed_leistung_id"
    t.integer "position"
    t.string  "parent_id"
  end

  create_table "classifications", :force => true do |t|
    t.text    "name"
    t.string  "code",                    :limit => 10
    t.integer "examination_method_id"
    t.integer "classification_group_id"
  end

  create_table "delievery_returns", :force => true do |t|
    t.integer  "case_id"
    t.datetime "fax_sent_at"
    t.integer  "bill_id"
    t.datetime "closed_at"
    t.datetime "address_verified_at"
  end

  create_table "doctors", :force => true do |t|
    t.string   "code"
    t.string   "speciality"
    t.integer  "praxis_vcard"
    t.integer  "private_vcard"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",            :default => true
    t.integer  "billing_doctor_id"
    t.string   "login"
    t.string   "password",                            :null => false
  end

  add_index "doctors", ["praxis_vcard"], :name => "doctors_praxis_vcard_index"
  add_index "doctors", ["private_vcard"], :name => "doctors_private_vcard_index"

  create_table "doctors_offices", :id => false, :force => true do |t|
    t.integer "office_id"
    t.integer "doctor_id"
  end

  create_table "employees", :force => true do |t|
    t.integer "work_vcard_id"
    t.integer "private_vcard_id"
    t.string  "code"
    t.date    "born_on"
    t.float   "workload"
  end

  create_table "examination_methods", :force => true do |t|
    t.string "name"
  end

  create_table "exports", :force => true do |t|
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer  "update_count", :default => 0
    t.integer  "create_count", :default => 0
    t.integer  "error_count",  :default => 0
    t.string   "error_ids",    :default => ""
    t.string   "model"
    t.string   "find_params"
    t.integer  "pid"
    t.integer  "record_count"
  end

  create_table "finding_classes", :force => true do |t|
    t.text "name"
    t.text "code"
  end

  create_table "finding_classes_finding_groups", :id => false, :force => true do |t|
    t.integer "finding_class_id"
    t.integer "finding_group_id"
  end

  create_table "finding_classes_second", :force => true do |t|
    t.text "name"
    t.text "code"
  end

  create_table "finding_groups", :force => true do |t|
    t.string "name"
  end

  create_table "honorific_prefixes", :force => true do |t|
    t.integer "sex"
    t.string  "name"
  end

  create_table "imports", :force => true do |t|
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer  "update_count", :default => 0
    t.integer  "create_count", :default => 0
    t.integer  "error_count",  :default => 0
    t.string   "error_ids",    :default => ""
    t.string   "model"
    t.string   "find_params"
    t.integer  "pid"
    t.integer  "record_count"
  end

  create_table "insurances", :force => true do |t|
    t.integer  "vcard_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mailings", :force => true do |t|
    t.datetime "created_at"
    t.integer  "doctor_id"
    t.datetime "printed_at"
    t.datetime "email_delivered_at"
  end

  add_index "mailings", ["created_at"], :name => "i1"
  add_index "mailings", ["doctor_id"], :name => "index_mailings_on_doctor_id"

  create_table "offices", :force => true do |t|
    t.string "name"
    t.string "login"
    t.string "password"
  end

  create_table "order_forms", :force => true do |t|
    t.text     "file"
    t.datetime "created_at"
    t.integer  "case_id"
  end

  add_index "order_forms", ["case_id"], :name => "index_order_forms_on_case_id"

  create_table "pages", :force => true do |t|
    t.integer "position"
    t.integer "scan_id"
    t.string  "file"
  end

  create_table "patients", :force => true do |t|
    t.integer  "vcard_id"
    t.date     "birth_date"
    t.integer  "insurance_id"
    t.string   "insurance_nr"
    t.integer  "sex"
    t.integer  "only_year_of_birth"
    t.integer  "doctor_id"
    t.integer  "billing_vcard_id"
    t.text     "remarks",             :limit => 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "dunning_stop",                       :default => false
    t.boolean  "use_billing_address",                :default => false
    t.boolean  "deceased",                           :default => false
    t.string   "doctor_patient_nr"
  end

  add_index "patients", ["billing_vcard_id"], :name => "patients_billing_vcard_id_index"
  add_index "patients", ["doctor_id"], :name => "patients_doctor_id_index"
  add_index "patients", ["insurance_id"], :name => "patients_insurance_id_index"
  add_index "patients", ["updated_at"], :name => "patients_updated_at_index"
  add_index "patients", ["vcard_id"], :name => "patients_vcard_id_index"

  create_table "payments", :force => true do |t|
  end

  create_table "phone_numbers", :force => true do |t|
    t.string  "number",            :limit => 50
    t.string  "phone_number_type", :limit => 50
    t.integer "vcard_id"
  end

  add_index "phone_numbers", ["vcard_id"], :name => "phone_numbers_vcard_id_index"

  create_table "praxistar_bill_journals", :force => true do |t|
  end

  create_table "scans", :force => true do |t|
    t.datetime "created_at"
  end

  create_table "schema_info", :id => false, :force => true do |t|
    t.integer "version"
  end

  create_table "shop_orders", :force => true do |t|
  end

  create_table "tasks", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "due_on"
    t.integer  "amount"
    t.integer  "employee_id"
    t.text     "type"
  end

  create_table "top_finding_classes", :force => true do |t|
    t.integer "classification_id"
    t.integer "finding_class_id"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                    :default => "passive"
    t.datetime "deleted_at"
    t.integer  "object_id"
    t.string   "object_type"
    t.boolean  "wants_email",                              :default => false
    t.boolean  "wants_prints",                             :default => true
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "vcards", :force => true do |t|
    t.string  "full_name",          :limit => 50
    t.string  "nickname",           :limit => 50
    t.integer "address"
    t.integer "billing_address_id"
    t.integer "address_id"
    t.string  "family_name",        :limit => 50
    t.string  "given_name",         :limit => 50
    t.string  "additional_name",    :limit => 50
    t.string  "honorific_prefix",   :limit => 50
    t.string  "honorific_suffix",   :limit => 50
  end

end
