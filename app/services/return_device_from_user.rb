# frozen_string_literal: true


class ReturnDeviceFromUser
  def initialize(user:, serial_number:, from_user:)
    @user = user
    @serial_number = serial_number
    @from_user = from_user
  end

    def call
      raise RegistrationError::Unauthorized, "Unauthorized" unless @user.id == @from_user
      
      device = Device.find_by(serial_number: @serial_number)
      raise ReturningError::NotFound, "Device not found" if device == nil
      raise ReturningError::NoOwner, "Device has no owner" if device.owner_id == nil
      raise RegistrationError::Unauthorized, "Unauthorized" unless device.owner_id == @from_user

      device.update!(owner_id: nil)
    end
end
