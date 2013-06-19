class AddPrimaryPocToEmployeesTable < ActiveRecord::Migration
  def up
  add_column :employees, :primary_poc, :string
  
  end

  def down
  remove_column :employees, :primary_poc
  
  end
end
