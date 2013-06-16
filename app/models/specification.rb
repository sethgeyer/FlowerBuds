class Specification < ActiveRecord::Base
  belongs_to :event
  has_many :designed_products
  belongs_to :florist
#  validates_presence_of :item_name, :item_quantity
end
