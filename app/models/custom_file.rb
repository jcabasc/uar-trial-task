# frozen_string_literal: true

class CustomFile < ApplicationRecord # :nodoc:
  self.per_page = 10
  validate :validate_sign_inclusion

  class << self
    def filter_by_tags(included_tags:, excluded_tags:, page:)
      where('tags @> ARRAY[?]::text[]', included_tags)
        .where.not('tags @> ARRAY[?]::text[]', excluded_tags)
        .paginate(page: page)
    end
  end

  private

  def validate_sign_inclusion
    errors.add(:tags, :invalid) if tags.detect { |tag| /\+|\-/.match(tag) }
  end
end
