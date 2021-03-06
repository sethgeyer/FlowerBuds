class Employee < ActiveRecord::Base
  belongs_to :florist
  has_many :events
  has_one :image
  attr_accessible :name, :status, :username, :password, :florist_id, :admin_rights
  validates_presence_of :name, :status, :username
  validates_uniqueness_of :username
  has_secure_password
end

