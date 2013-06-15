class Florist < ActiveRecord::Base
  has_many :employees
  has_many :customers
  has_many :products
  
  has_many :designed_products
  has_many :events
  has_many :quotes
  has_many :specifications 
  attr_accessible :name, :company_logo, :company_id
end
