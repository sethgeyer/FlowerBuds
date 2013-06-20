class AddImageToSpecifications < ActiveRecord::Migration
  def change
    add_column :specifications, :image1, :string
  end
end
