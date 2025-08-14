class Device < ApplicationRecord
  belongs_to :owner, class_name: "User", optional: true
  
  has_many :blacklists
  has_many :blacklisted_users, class_name: "User", through: :blacklists

  validates :serial_number, presence: true, uniqueness: true
end
