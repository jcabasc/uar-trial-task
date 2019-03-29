# frozen_string_literal: true

module Api
  module V1
    class FileResource < JSONAPI::Resource # :nodoc:
      model_name 'CustomFile'
      attributes :id
    end
  end
end
