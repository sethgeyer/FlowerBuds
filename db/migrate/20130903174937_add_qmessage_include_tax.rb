class AddQmessageIncludeTax < ActiveRecord::Migration
  def up
  add_column :florists, :quote_message_default, :string, :limit => 1000
  end

  def down
  remove_column :florists, :quote_message_default
  end
end
