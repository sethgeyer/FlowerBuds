class TotalCostColumn < ActiveRecord::Migration
  def up
  add_column :quotes, :total_cost, :integer
  end

  def down
  remove_column :quotes, :total_cost
  end
end
