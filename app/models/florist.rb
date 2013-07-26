class Florist < ActiveRecord::Base
  has_many :employees
  has_many :customers
  has_many :products
  
  has_many :designed_products
  has_many :events
  has_many :quotes
  has_many :specifications
  has_many :images 
  attr_accessible :name, :company_id
  validates_presence_of :name, :company_id, :status
  validates_uniqueness_of :company_id
end
