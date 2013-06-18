class Employee < ActiveRecord::Base
  belongs_to :florist
  has_many :events
  attr_accessible :name, :status, :username, :password, :florist_id, :admin_rights
  validates_presence_of :name, :status, :username
  has_secure_password
end

