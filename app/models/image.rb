class Image < ActiveRecord::Base
  belongs_to :specification
  belongs_to :florist
  belongs_to :employee
  belongs_to :product
end
