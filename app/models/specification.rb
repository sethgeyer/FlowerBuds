class Specification < ActiveRecord::Base
  belongs_to :event
  has_many :designed_products
  belongs_to :florist
end
