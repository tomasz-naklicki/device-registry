# frozen_string_literal: true

FactoryBot.define do
  factory :device do
    sequence(:serial_number) { |n| "#{1000+n}" }
    association :owner, factory: :user

  end
end