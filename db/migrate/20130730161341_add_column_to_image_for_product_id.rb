class AddColumnToImageForProductId < ActiveRecord::Migration
   def up
  add_column :images, :product_id, :integer
  end

  def down
  remove_column :images, :product_id
  end
end
