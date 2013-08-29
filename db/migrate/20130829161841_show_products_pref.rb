class ShowProductsPref < ActiveRecord::Migration
  def up
   add_column :florists, :show_product_image_pref, :integer
   add_column :events, :show_product_image, :integer
  end

  def down
  remove_column :florists, :show_product_image_pref
  remove_column :events, :show_product_image
  end
  
end
