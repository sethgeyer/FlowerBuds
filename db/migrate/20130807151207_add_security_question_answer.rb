class AddSecurityQuestionAnswer < ActiveRecord::Migration
  def up
    add_column :employees, :q_and_a, :string 
  end

  def down
    drop_column :employees, :q_and_a
  end
end


