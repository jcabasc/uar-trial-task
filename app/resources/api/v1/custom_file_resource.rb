# frozen_string_literal: true

module Api
  module V1
    class CustomFileResource < JSONAPI::Resource # :nodoc:
      attributes :name
    end
  end
end
