# frozen_string_literal: true

  require 'rails_helper'

RSpec.describe ReturnDeviceFromUser do
  subject(:return_device) do
    described_class.new(
      user: user,
      serial_number: serial_number,
      from_user: user.id
    ).call
  end
  
  let(:serial_number) { '123456' }
  let(:user) { create(:user) }
  
  
  context 'when user owns the device' do
    let!(:device) { create(:device, serial_number: serial_number, owner: user) }
    
    it 'removes ownership from the device' do
      expect { return_device } 
      .to change { device.reload.owner_id }
      .from(user.id)
      .to(nil)
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
  

  context 'when the user does not own the device' do
    let(:other_user) { create(:user) }
    let!(:device) { create(:device, serial_number: serial_number, owner: other_user) }

    it 'does not allow to return' do
      expect { return_device }
        .to raise_error(RegistrationError::Unauthorized)
    end
  end

  context 'when the device does not exist' do
    let(:device) {nil}

    it 'does not allow to return' do

      expect { return_device }
        .to raise_error(ReturningError::NotFound)
    end
  end

  context 'when the device has no owner' do
    let(:device) { create(:device, serial_number: serial_number, owner: nil) }
    it 'does not allow to return' do
      expect(device.owner).to eq(nil) 
      expect { return_device }
        .to raise_error(ReturningError::NoOwner)
    end
  end




end
