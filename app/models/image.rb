class Image < ActiveRecord::Base
  belongs_to :specification
  belongs_to :florist
  belongs_to :employee
end
