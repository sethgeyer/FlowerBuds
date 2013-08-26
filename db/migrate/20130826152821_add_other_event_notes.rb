class AddOtherEventNotes < ActiveRecord::Migration
  def up
    add_column :events, :other_notes, :string, :limit => 1000
  end

  def down
    remove_column :events, :other_notes
  end
end
