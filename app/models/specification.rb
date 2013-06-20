class Specification < ActiveRecord::Base
  belongs_to :event
  has_many :designed_products
  belongs_to :florist
  validates_presence_of :item_quantity
 # attr_accessible :image1
 # mount_uploader :image1, ImageUploader
  
end
