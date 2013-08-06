class ExcludeFromQuote < ActiveRecord::Migration
  def up
  add_column :specifications, :exclude_from_quote, :integer
  end

  def down
  drop_column :specifications, :exclude_from_quote
  end
end
