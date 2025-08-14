class User < ApplicationRecord
  has_many :api_keys, as: :bearer
  has_many :devices, dependent: :nullify, foreign_key: :owner_id
  
  has_many :blacklists
  has_many :blacklisted_devices, class_name: "Device", through: :blacklists

  has_secure_password
end
