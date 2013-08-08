class AddPrefernceColumn < ActiveRecord::Migration
  def up
  add_column :employees, :view_pref, :string
  end

  def down
  remove_column :employees, :view_pref
  end
end
