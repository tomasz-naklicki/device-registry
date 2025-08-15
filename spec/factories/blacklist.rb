FactoryBot.define do
  factory :blacklist do
    association :user
    association :device
  end
end