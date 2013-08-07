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

ActiveRecord::Schema.define(:version => 20130807151207) do

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "email"
    t.string   "groom_name"
    t.string   "groom_phone"
    t.string   "groom_email"
    t.string   "company_name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "notes",        :limit => 1000
    t.integer  "florist_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "updated_by"
  end

  create_table "designed_products", :force => true do |t|
    t.integer  "event_id"
    t.integer  "specification_id"
    t.integer  "product_id"
    t.integer  "product_qty"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "updated_by"
    t.integer  "florist_id"
    t.integer  "image_in_quote"
    t.integer  "image_on_cover"
  end

  create_table "employees", :force => true do |t|
    t.string   "name"
    t.string   "status"
    t.string   "email"
    t.string   "w_phone"
    t.string   "c_phone"
    t.string   "employee_type"
    t.string   "username"
    t.string   "password_digest"
    t.integer  "florist_id"
    t.string   "admin_rights"
    t.string   "password"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "updated_by"
    t.string   "primary_poc"
    t.string   "view_pref"
    t.string   "q_and_a"
  end

  create_table "events", :force => true do |t|
    t.string   "event_type"
    t.string   "name"
    t.date     "date_of_event"
    t.string   "time"
    t.string   "delivery_setup_time"
    t.string   "notes",               :limit => 1000
    t.string   "feel_of_day"
    t.string   "color_palette"
    t.string   "flower_types"
    t.string   "attire"
    t.integer  "employee_id"
    t.integer  "customer_id"
    t.string   "photographer"
    t.string   "coordinator"
    t.string   "locations"
    t.string   "budget"
    t.string   "event_status"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "updated_by"
    t.integer  "florist_id"
    t.integer  "random_number"
  end

  create_table "florists", :force => true do |t|
    t.string   "name"
    t.string   "company_logo"
    t.string   "company_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "updated_by"
    t.string   "status"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
  end

  create_table "images", :force => true do |t|
    t.binary   "data",             :null => false
    t.string   "extension",        :null => false
    t.string   "content_type",     :null => false
    t.integer  "on_quote_cover"
    t.integer  "florist_id"
    t.integer  "specification_id"
    t.string   "image_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "employee_id"
    t.integer  "product_id"
  end

  create_table "products", :force => true do |t|
    t.string   "product_type"
    t.string   "name"
    t.integer  "items_per_bunch"
    t.integer  "cost_per_bunch"
    t.integer  "cost_for_one"
    t.integer  "markup"
    t.string   "status"
    t.integer  "florist_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "updated_by"
  end

  create_table "quotes", :force => true do |t|
    t.string   "quote_name"
    t.integer  "event_id"
    t.integer  "total_price"
    t.integer  "markup"
    t.string   "status"
    t.date     "wholesale_order_date"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "updated_by"
    t.integer  "florist_id"
    t.integer  "total_cost"
  end

  create_table "specifications", :force => true do |t|
    t.integer  "event_id"
    t.string   "item_name"
    t.integer  "item_quantity"
    t.string   "item_specs",          :limit => 1000
    t.boolean  "in_quote"
    t.integer  "per_item_cost"
    t.integer  "per_item_list_price"
    t.integer  "extended_list_price"
    t.integer  "quoted_price"
    t.string   "image"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "updated_by"
    t.integer  "florist_id"
    t.string   "image1"
    t.integer  "exclude_from_quote"
  end

end
