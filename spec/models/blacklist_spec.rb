require 'rails_helper'

RSpec.describe Blacklist, type: :model do
   describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:device) }
  end

  describe 'validations' do
    subject { create(:blacklist) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:device_id) }
  end
end

