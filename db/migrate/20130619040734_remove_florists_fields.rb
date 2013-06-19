class RemoveFloristsFields < ActiveRecord::Migration
  def up
  remove_column :florists, :primary_poc
  remove_column :florists, :poc_email
  remove_column :florists, :poc_phone_w
  remove_column :florists, :poc_phone_c
  
  end

  def down
  add_column :florists, :primary_poc, :string
  add_column :florists, :poc_email, :string
  add_column :florists, :poc_phone_w, :string
  add_column :florists, :poc_phone_c, :string
  end
end
