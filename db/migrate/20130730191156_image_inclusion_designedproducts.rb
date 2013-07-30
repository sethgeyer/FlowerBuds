class ImageInclusionDesignedproducts < ActiveRecord::Migration
  def up
  add_column :designed_products, :image_in_quote, :integer
  add_column :designed_products, :image_on_cover, :integer
  end

  def down
  drop_column :designed_products, :image_in_quote
  drop_column :designed_products, :image_on_cover
  end
end

