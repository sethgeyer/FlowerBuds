class RenameExtension < ActiveRecord::Migration
  def up
   rename_column :images, :extension, :extens
  end

  def down
  rename_column :images, :extens, :extension
  end
end
