class AddRandomNumber < ActiveRecord::Migration
  def up
  add_column :events, :random_number, :integer
  end

  def down
  remove_column :events, :random_number 
  end
end
