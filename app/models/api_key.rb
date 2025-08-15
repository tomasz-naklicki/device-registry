# frozen_string_literal: true

class ApiKey < ApplicationRecord
  belongs_to :bearer, polymorphic: true

  before_create :generate_token

  private

  def generate_token
    self.token ||= SecureRandom.hex(20)
  end
end
