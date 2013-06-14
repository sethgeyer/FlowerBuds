class Customer < ActiveRecord::Base
  has_many :events
  belongs_to :florist 
  attr_accessible :name, :florist_id
end
