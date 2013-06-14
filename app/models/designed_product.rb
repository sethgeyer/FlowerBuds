class DesignedProduct < ActiveRecord::Base
  belongs_to :specification
  belongs_to :product
  belongs_to :event
end
