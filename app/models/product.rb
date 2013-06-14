class Product < ActiveRecord::Base
  has_many :designed_products
  belongs_to :florist
  attr_accessible :product_type, :name, :items_per_bunch, :cost_per_bunch, :cost_for_one, :markup, :status, :florist_id
end
