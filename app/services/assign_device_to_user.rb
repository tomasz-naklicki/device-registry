# frozen_string_literal: true

class AssignDeviceToUser
  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id
  end

  def call
    unless @requesting_user.id == @new_device_owner_id
      raise RegistrationError::Unauthorized, "Unauthorized"
    end

    device = Device.find_or_create_by!(serial_number: @serial_number)
    
    if Blacklist.exists?(user_id: @new_device_owner_id, device_id: device.id)
      raise AssigningError::AlreadyUsedOnUser, "Cannot reassign device"
    end

    if device.owner_id.present? && device.owner_id != @requesting_user.id
      raise AssigningError::AlreadyUsedOnOtherUser, "Device already assigned to a different user"
    end
    
    ApplicationRecord.transaction do
      Blacklist.create!(user_id: @new_device_owner_id, device_id: device.id)
      device.update!(owner_id: @new_device_owner_id)
    end
    device
  end
end
