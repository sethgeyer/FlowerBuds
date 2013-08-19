class QuoteMessage < ActiveRecord::Migration
   def up
   add_column :events, :quote_message, :string, :limit => 1000

  end

  def down
  remove_column :events, :quote_message
  end
end
