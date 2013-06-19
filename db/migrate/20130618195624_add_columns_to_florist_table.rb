class AddColumnsToFloristTable < ActiveRecord::Migration
  def up
  add_column :florists, :status, :string
  add_column :florists, :primary_poc, :string
  add_column :florists, :poc_email, :string
  add_column :florists, :poc_phone_w, :string
  add_column :florists, :poc_phone_c, :string
  add_column :florists, :city, :string
  add_column :florists, :state, :string
  add_column :florists, :zip, :string
  end

  def down
  remove_column :florists, :status
  remove_column :florists, :primary_poc
  remove_column :florists, :poc_email
  remove_column :florists, :poc_phone_w
  remove_column :florists, :poc_phone_c
  remove_column :florists, :city
  remove_column :florists, :state
  remove_column :florists, :zip

  end
end
