class Quote < ActiveRecord::Base
  belongs_to :event
  belongs_to :florist  
end
