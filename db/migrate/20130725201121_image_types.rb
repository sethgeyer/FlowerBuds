class ImageTypes < ActiveRecord::Migration
  def up
  rename_column :images, :caption, :image_type
  end

  def down
  rename_column :images, :image_type, :caption
  end
end
