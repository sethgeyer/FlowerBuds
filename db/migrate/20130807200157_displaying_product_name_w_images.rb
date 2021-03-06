class DisplayingProductNameWImages < ActiveRecord::Migration
  def up
  add_column :images, :display_name, :string
  add_column :products, :display_name, :string
  add_column :events, :show_display_name, :integer
  end

  def down
  remove_column :images, :display_name
  remove_column :products, :display_name
  remove_column :events, :show_display_name
  end
end
