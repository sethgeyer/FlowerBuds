class Product < ActiveRecord::Base
  has_many :designed_products
  has_one :image
  belongs_to :florist
  attr_accessible :product_type, :name, :items_per_bunch, :cost_per_bunch, :cost_for_one, :markup, :status, :florist_id
  validates_presence_of :product_type, :name, :items_per_bunch, :cost_per_bunch, :markup, :status
end
