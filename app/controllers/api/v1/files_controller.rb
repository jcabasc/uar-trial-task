# frozen_string_literal: true

module Api
  module V1
    class FilesController < ActionController::API # :nodoc:
      include JSONAPI::ActsAsResourceController
      include ErrorHandler

      def create
        file = CustomFile.create!(file_params)
        render_response(file, :ok)
      end

      private

      def render_response(file, status)
        resource = Api::V1::FileResource.new(file, nil)
        render json: serializer.serialize_to_hash(resource), status: status
      end

      def file_params
        params.require(:data).require(:attributes).permit(:name, tags: [])
      end

      def serializer
        JSONAPI::ResourceSerializer.new(Api::V1::FileResource)
      end
    end
  end
end
