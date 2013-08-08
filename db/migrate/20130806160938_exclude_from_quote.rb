class ExcludeFromQuote < ActiveRecord::Migration
  def up
  add_column :specifications, :exclude_from_quote, :integer
  end

  def down
  remove_column :specifications, :exclude_from_quote
  end
end
