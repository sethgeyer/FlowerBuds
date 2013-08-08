class AddEmployeeImage < ActiveRecord::Migration
  def up
  add_column :images, :employee_id, :integer
  end

  def down
  remove_column :images, :employee_id
  end
end
