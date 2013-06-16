class Quote < ActiveRecord::Base
  belongs_to :event
  belongs_to :florist 
  validates_presence_of :quote_name 
end
