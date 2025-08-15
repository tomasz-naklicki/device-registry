require 'rails_helper'

RSpec.describe Device, type: :model do
  describe 'associations' do
    it { should belong_to(:owner).class_name('User').optional }
    it { should have_many(:blacklists) }
    it { should have_many(:blacklisted_users).class_name('User').through(:blacklists) }
  end

  describe 'validations' do
    it { should validate_presence_of(:serial_number) }
    it { should validate_uniqueness_of(:serial_number) }
  end

  describe '#assigned?' do
    it 'returns true if owner_id is present' do
      device = create(:device, owner: create(:user))
      expect(device.assigned?).to be true
    end

    it 'returns false if owner_id is nil' do
      device = create(:device, owner: nil)
      expect(device.assigned?).to be false
    end
  end

  describe '#assigned_to_user?' do
    let(:user) { create(:user) }

    it 'returns true if the device belongs to the user' do
      device = create(:device, owner: user)
      expect(device.assigned_to_user?(user)).to be true
    end

    it 'returns false if the device belongs to another user' do
      device = create(:device, owner: create(:user))
      expect(device.assigned_to_user?(user)).to be false
    end

    it 'returns false if the device has no owner' do
      device = create(:device, owner: nil)
      expect(device.assigned_to_user?(user)).to be false
    end
  end
end
