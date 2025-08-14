# frozen_string_literal: true
require 'rspec'
require 'rails_helper'

RSpec.describe ReturnDeviceFromUser do
  subject(:return_device) do
    described_class.new(
      requesting_user: user,
      serial_number: serial_number
    ).call
  end

  let(:serial_number) { '123456' }
  let(:user) { create(:user) }
  let(:device) { create(:device, serial_number: serial_number, owner_id: owner_id) }

  before do
    device # ensure device exists
  end

  context 'when user owns the device' do
    let(:owner_id) {user.id}

    it 'removes ownership from the device' do
      expect { return_device } 
        .to change { device.reload.owner_id }
        .from(user.id)
        .to(nil)
    end
  end

  context 'when the user does not own the device' do
    let(:owner_id) { create(:user).id }

    it 'does not allow to return' do
      expect { return_device }
        .to raise_error(ReturningError::Unauthorized)
    end
  end

  context 'when the device does not exist' do
    let(:serial_number) { 'nonexistent' }
    let(:owner_id) { nil }

    it 'does not allow to return' do
      expect { return_device }
        .to raise_error(ReturningError::DeviceDoesNotExist)
    end
  end

  context 'when the device has no owner' do
    let(:owner_id) { nil }

    it 'does not allow to return' do
      expect { return_device }
        .to raise_error(ReturningError::DeviceHasNoOwner)
    end
  end

  context 'when the user owns multiple devices' do
    let(:serial_number) { '111111' }
    let(:owner_id) { user.id }
    let!(:other_device) { create(:device, serial_number: '222222', owner_id: user.id) }
    it 'only removes the correct device' do
      return_device
      expect(device.reload.owner_id).to be_nil
      expect(other_device.reload.owner_id).to eq(user.id)
    end
  end



end
