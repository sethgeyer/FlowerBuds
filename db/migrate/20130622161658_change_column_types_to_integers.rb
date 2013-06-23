class ChangeColumnTypesToIntegers < ActiveRecord::Migration
  def up
  change_column :designed_products, :product_qty, :integer
  change_column :products, :items_per_bunch, :integer
  change_column :products, :cost_per_bunch, :integer
  change_column :products, :cost_for_one, :integer
  change_column :products, :markup, :integer
  change_column :quotes, :total_price, :integer
  change_column :quotes, :markup, :integer
  change_column :specifications, :item_quantity, :integer
  change_column :specifications, :per_item_cost, :integer
  change_column :specifications, :per_item_list_price, :integer
  change_column :specifications, :extended_list_price, :integer
  change_column :specifications, :quoted_price, :integer  
  
  
  end

  def down
  change_column :designed_products, :product_qty, :float
  change_column :products, :items_per_bunch, :float
  change_column :products, :cost_per_bunch, :float
  change_column :products, :cost_for_one, :float
  change_column :products, :markup, :float
  change_column :quotes, :total_price, :float
  change_column :quotes, :markup, :float
  change_column :specifications, :item_quantity, :integer
  change_column :specifications, :per_item_cost, :integer
  change_column :specifications, :per_item_list_price, :integer
  change_column :specifications, :extended_list_price, :integer
  change_column :specifications, :quoted_price, :integer  
  
  
  
  end
end
