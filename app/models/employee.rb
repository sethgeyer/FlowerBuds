class Employee < ActiveRecord::Base
  belongs_to :florist
  has_many :events
  attr_accessible :name, :status, :username, :password, :florist_id, :admin_rights
end

