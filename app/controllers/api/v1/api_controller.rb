# frozen_string_literal: true

module Api
  module V1
    class APIController < ActionController::API # :nodoc:
      include JSONAPI::ActsAsResourceController
      include ErrorHandler

      def render_response(object_s, resource_name, status, meta = {})
        resource_s = if object_s.is_a?(Array) || object_s.is_a?(ActiveRecord::Relation)
                       object_s.map { |file| CustomFileResource.new(file, nil) }
                     else
                       Api::V1::FileResource.new(object_s, nil)
                     end
        serializer = response_serializer_for(resource_name)
        render json: serializer.serialize_to_hash(resource_s).merge(meta),
               status: status
      end

      def response_serializer_for(resource_name)
        JSONAPI::ResourceSerializer
          .new("Api::V1::#{resource_name}Resource".constantize)
      end
    end
  end
end
