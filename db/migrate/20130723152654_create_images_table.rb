class CreateImagesTable < ActiveRecord::Migration
  def up
  create_table :images do |t|
  t.binary  :data, null: false
  t.string  :extension, null: false
  t.string  :content_type, null: false
  t.integer :on_quote_cover
  t.integer :florist_id
  t.integer :specification_id
  t.string  :caption
  t.timestamps
  end
  end

  def down
  drop_table :images
  end
end
