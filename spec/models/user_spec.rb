require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:api_keys).as(:bearer) }
    it { should have_many(:devices).dependent(:nullify).with_foreign_key(:owner_id) }
    it { should have_many(:blacklists) }
    it { should have_many(:blacklisted_devices).class_name('Device').through(:blacklists) }
  end

  describe 'secure password' do
    it { should have_secure_password }
  end

  describe '#owns_device?' do
    let(:user) { create(:user) }

    it 'returns true if the user owns the device' do
      device = create(:device, owner: user)
      expect(user.owns_device?(device)).to be true
    end

    it 'returns false if the user does not own the device' do
      device = create(:device, owner: create(:user))
      expect(user.owns_device?(device)).to be false
    end
  end
end