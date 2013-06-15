class AddFloristIds < ActiveRecord::Migration
  def up
  add_column :designed_products, :florist_id, :integer
  add_column :events, :florist_id, :integer
  add_column :quotes, :florist_id, :integer
  add_column :specifications, :florist_id, :integer
  end

  def down
  remove_column :designed_products, :florist_id
  remove_column :events, :florist_id
  remove_column :quotes, :florist_id
  remove_column :specifications, :florist_id
  end
end
