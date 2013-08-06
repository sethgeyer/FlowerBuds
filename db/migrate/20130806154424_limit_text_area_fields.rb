class LimitTextAreaFields < ActiveRecord::Migration
  def up
  change_column :specifications, :item_specs, :string, :limit => 1000
  change_column :customers, :notes, :string, :limit => 1000
  change_column :events, :notes, :string, :limit => 1000 
  end

  def down
  change_column :specifications, :item_specs, :string, :limit => 500
  change_column :customers, :notes, :string, :limit => 500 
  change_column :events, :notes, :string 

  end
end



