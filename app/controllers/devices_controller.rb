# frozen_string_literal: true

class DevicesController < ApplicationController
  before_action :authenticate_user!, only: %i[assign unassign]
  def assign
    begin
      AssignDeviceToUser.new(
        requesting_user: @current_user,
        serial_number: params[:device][:serial_number],
        new_device_owner_id: params[:new_owner_id].to_i
      ).call
      head :ok
    rescue RegistrationError::Unauthorized => e
      render json: {error: e.message}, status: 422
    rescue AssigningError => e
      render json: {error: e.message}, status: 422
    end
  end

  def unassign
    begin
      ReturnDeviceFromUser.new(
        user: @current_user,
        serial_number: params[:device][:serial_number],
        from_user: params[:from_user].to_i
      ).call
      head :ok
    rescue RegistrationError::Unauthorized => e
      render json: {error: e.message}, status: 422
    rescue ReturningError => e
      render json: {error: e.message}, status: 422
    end
  end

  private

  def device_params
    params.permit(:new_owner_id, :serial_number)
  end
end
