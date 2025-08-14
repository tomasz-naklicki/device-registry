class User < ApplicationRecord
  has_many :api_keys, as: :bearer
  has_many :devices, dependent: :nullify
  
  has_many :blacklists, dependent: :destroy
  has many :blacklisted_devices, class_name: "Device", through: :blacklists

  has_secure_password
end
