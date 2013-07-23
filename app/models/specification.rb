class Specification < ActiveRecord::Base
  belongs_to :event
  has_many :designed_products
  has_many :images
  belongs_to :florist
  validates_presence_of :item_quantity
end
