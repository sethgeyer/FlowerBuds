class Specification < ActiveRecord::Base
  belongs_to :event
  has_many :designed_products
end
