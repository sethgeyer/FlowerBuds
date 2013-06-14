class Event < ActiveRecord::Base
  belongs_to :customer
  has_many :specifications
  belongs_to :employee
  has_many :designed_products
  has_one :quote
end
