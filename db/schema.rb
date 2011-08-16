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

ActiveRecord::Schema.define(:version => 20110816074156) do

  create_table "addresses", :force => true do |t|
    t.string  "post_office_box",  :limit => 50
    t.string  "extended_address", :limit => 50
    t.string  "street_address",   :limit => 50
    t.string  "locality",         :limit => 50
    t.string  "region",           :limit => 50
    t.string  "postal_code",      :limit => 50
    t.string  "country_name",     :limit => 50
    t.integer "vcard_id"
    t.string  "address_type"
  end

  add_index "addresses", ["locality"], :name => "locality"
  add_index "addresses", ["vcard_id"], :name => "addresses_vcard_id_index"

  create_table "aetikettens", :force => true do |t|
    t.string   "hon_suffix"
    t.string   "fam_name"
    t.string   "giv_name"
    t.string   "ext_address"
    t.string   "loc"
    t.string   "postc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.boolean  "needs_hpv",                                :default => false
    t.boolean  "needs_review",                             :default => false
    t.integer  "first_entry_by"
    t.datetime "first_entry_at"
    t.integer  "review_by"
    t.datetime "review_at"
    t.datetime "p16_notice_printed_at"
    t.datetime "email_sent_at"
  end

  add_index "cases", ["assigned_at"], :name => "assigned_at"
  add_index "cases", ["doctor_id"], :name => "doctor_id"
  add_index "cases", ["entry_date"], :name => "entry_date"
  add_index "cases", ["insurance_id"], :name => "cases_insurance_id_index"
  add_index "cases", ["insurance_nr"], :name => "insurance_nr"
  add_index "cases", ["needs_hpv"], :name => "needs_hpv"
  add_index "cases", ["needs_p16"], :name => "needs_p16"
  add_index "cases", ["needs_review"], :name => "needs_review"
  add_index "cases", ["patient_id"], :name => "patient_id"
  add_index "cases", ["praxistar_eingangsnr"], :name => "praxistar_eingangsnr"
  add_index "cases", ["praxistar_leistungsblatt_id"], :name => "praxistar_leistungsblatt_id"
  add_index "cases", ["result_report_printed_at"], :name => "i1"
  add_index "cases", ["screened_at"], :name => "screened_at"

  create_table "cases_finding_classes", :id => false, :force => true do |t|
    t.integer "case_id"
    t.integer "finding_class_id"
    t.integer "position"
  end

  add_index "cases_finding_classes", ["case_id", "finding_class_id"], :name => "cases_finding_classes_case_id_index", :unique => true

  create_table "cases_mailings", :id => false, :force => true do |t|
    t.integer "case_id"
    t.integer "mailing_id"
  end

  add_index "cases_mailings", ["case_id"], :name => "index_cases_mailings_on_case_id"
  add_index "cases_mailings", ["mailing_id"], :name => "index_cases_mailings_on_mailing_id"

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

  create_table "doctors", :id => false, :force => true do |t|
    t.integer  "id",                                  :null => false
    t.string   "code"
    t.string   "speciality"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",            :default => true
    t.integer  "billing_doctor_id"
    t.string   "login"
    t.string   "password",                            :null => false
  end

  add_index "doctors", ["active"], :name => "active"
  add_index "doctors", ["id"], :name => "id"

  create_table "doctors_offices", :id => false, :force => true do |t|
    t.integer "office_id"
    t.integer "doctor_id"
  end

  add_index "doctors_offices", ["doctor_id"], :name => "doctor_id"
  add_index "doctors_offices", ["office_id"], :name => "office_id"

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
    t.text    "name"
    t.text    "code"
    t.integer "finding_group_id"
  end

  add_index "finding_classes", ["finding_group_id"], :name => "index_finding_classes_on_finding_group_id"

  create_table "finding_groups", :force => true do |t|
    t.string "name"
  end

  create_table "honorific_prefixes", :force => true do |t|
    t.integer "sex"
    t.string  "name"
  end

  create_table "insurances", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mailings", :force => true do |t|
    t.datetime "created_at"
    t.integer  "doctor_id"
    t.datetime "printed_at"
    t.datetime "email_delivered_at"
    t.datetime "hl7_delivered_at"
  end

  add_index "mailings", ["created_at"], :name => "i1"
  add_index "mailings", ["doctor_id"], :name => "index_mailings_on_doctor_id"

  create_table "new_view", :id => false, :force => true do |t|
    t.datetime "screened_at"
    t.integer  "doctor_id"
  end

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

  create_table "ot_labels", :force => true do |t|
    t.text     "prax_nr"
    t.integer  "sys_id"
    t.text     "doc_fname"
    t.text     "doc_gname"
    t.text     "pat_fname"
    t.text     "pat_gname"
    t.text     "pat_bday"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patients", :force => true do |t|
    t.date     "birth_date"
    t.integer  "insurance_id"
    t.string   "insurance_nr"
    t.integer  "sex"
    t.integer  "only_year_of_birth"
    t.integer  "doctor_id"
    t.text     "remarks",             :limit => 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "dunning_stop",                       :default => false
    t.boolean  "use_billing_address",                :default => false
    t.boolean  "deceased",                           :default => false
    t.string   "doctor_patient_nr"
  end

  add_index "patients", ["birth_date"], :name => "birth_date"
  add_index "patients", ["doctor_id"], :name => "patients_doctor_id_index"
  add_index "patients", ["insurance_id"], :name => "patients_insurance_id_index"
  add_index "patients", ["updated_at"], :name => "patients_updated_at_index"

  create_table "phone_numbers", :force => true do |t|
    t.string  "number",            :limit => 50
    t.string  "phone_number_type", :limit => 50
    t.string  "object_type"
    t.integer "object_id"
  end

  add_index "phone_numbers", ["object_id", "object_type"], :name => "index_phone_numbers_on_object_id_and_object_type"

  create_table "postal_codes", :force => true do |t|
    t.string   "zip_type"
    t.string   "zip"
    t.string   "zip_extension"
    t.string   "locality"
    t.string   "locality_long"
    t.string   "canton"
    t.integer  "imported_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "postal_codes", ["zip"], :name => "index_postal_codes_on_zip"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "send_queues", :force => true do |t|
    t.integer  "mailing_id"
    t.string   "channel"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "sent_at"
    t.text     "output"
  end

  add_index "send_queues", ["channel"], :name => "index_send_queues_on_channel"
  add_index "send_queues", ["mailing_id"], :name => "index_send_queues_on_mailing_id"
  add_index "send_queues", ["sent_at"], :name => "index_send_queues_on_sent_at"

  create_table "top_finding_classes", :id => false, :force => true do |t|
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
    t.boolean  "wants_hl7",                                :default => false
    t.string   "encrypted_password",        :limit => 128, :default => "",        :null => false
    t.integer  "sign_in_count",                            :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                          :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["object_id"], :name => "object_id"
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true
  add_index "users", ["wants_email"], :name => "wants_email"

  create_table "vcards", :force => true do |t|
    t.string  "full_name",        :limit => 50
    t.string  "nickname",         :limit => 50
    t.string  "family_name",      :limit => 50
    t.string  "given_name",       :limit => 50
    t.string  "additional_name",  :limit => 50
    t.string  "honorific_prefix", :limit => 50
    t.string  "honorific_suffix", :limit => 50
    t.boolean "active",                         :default => true
    t.integer "object_id"
    t.string  "object_type"
    t.string  "vcard_type"
  end

  add_index "vcards", ["family_name"], :name => "family_name"
  add_index "vcards", ["full_name"], :name => "full_name"
  add_index "vcards", ["given_name"], :name => "given_name"
  add_index "vcards", ["object_id", "object_type"], :name => "index_vcards_on_object_id_and_object_type"

end
