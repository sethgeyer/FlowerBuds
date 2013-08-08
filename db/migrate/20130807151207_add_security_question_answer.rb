class AddSecurityQuestionAnswer < ActiveRecord::Migration
  def up
    add_column :employees, :q_and_a, :string 
  end

  def down
    remove_column :employees, :q_and_a
  end
end


