class QuoteLanguage < ActiveRecord::Migration
  def up
   add_column :florists, :quote_language, :string, :limit => 5000

  end

  def down
  remove_column :florists, :quote_language
  end
end
