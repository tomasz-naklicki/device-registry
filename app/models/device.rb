class Device < ApplicationRecord
  belongs_to :owner, class_name: "User", optional: true
  
  has_many :blacklists
  has_many :blacklisted_users, class_name: "User", through: :blacklists, source: :user

  validates :serial_number, presence: true, uniqueness: true

  def assigned?
    owner_id.present?
  end

  def assigned_to_user?(user)
    owner_id == user&.id
  end

end
