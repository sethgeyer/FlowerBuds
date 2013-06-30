class ChangeCharacterLength < ActiveRecord::Migration
  def up
  change_column :specifications, :item_specs, :string, :limit => 500
  
  end

  def down
  change_column :specifications, :item_specs, :string
 
  end
end
