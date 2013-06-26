class RemovePType < ActiveRecord::Migration
  def up
  remove_column :designed_products, :product_type
  end

  def down
  add_column :designed_products, :product_type, :string
  end
end
