class Florist < ActiveRecord::Base
  has_many :employees
  has_many :customers
  has_many :products 
  attr_accessible :name, :company_logo, :company_id
end
