class QuoteStyle < ActiveRecord::Migration
   def up
   add_column :quotes, :quote_style, :integer

  end

  def down
  remove_column :quotes, :quote_style
  end
end
