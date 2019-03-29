# frozen_string_literal: true

class CustomFile < ApplicationRecord # :nodoc:
  validate :validate_sign_inclusion
  self.per_page = 10

  def validate_sign_inclusion
    if tags.detect{|tag| /\+|\-/.match(tag)}
      errors.add(:tags, :invalid)
    end
  end
end
