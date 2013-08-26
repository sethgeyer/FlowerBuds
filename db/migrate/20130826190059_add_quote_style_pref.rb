class AddQuoteStylePref < ActiveRecord::Migration
  def up
   add_column :florists, :quote_style_pref, :integer
   add_column :florists, :custom_quote, :integer
  end

  def down
  remove_column :florists, :quote_style_pref
  remove_column :florists, :custom_quote
  end
end
