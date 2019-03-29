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

      def index
        files = CustomFile
                .where('tags @> ARRAY[?]::text[]', included_tags)
                .where.not('tags @> ARRAY[?]::text[]', excluded_tags)
                .paginate(page: params[:page])
        meta = { meta: meta_params(files.to_a) }
        file_resources = files.map { |file| CustomFileResource.new(file, nil) }
        render json: serializer.serialize_to_hash(file_resources).merge(meta)
      end

      private

      def file_params
        params.require(:data).require(:attributes).permit(:name, tags: [])
      end

      def filter_params
        params.permit(:tag_search_query, :page)
      end

      def meta_params(files)
        related_tags = get_all_related_tags(files)
        {
          total_records: files.size,
          related_tags: related_tags.map do |tag|
            {
              tag: tag,
              file_count: files.select { |x| x.tags.include?(tag) }.size
            }
          end
        }
      end

      def render_response(file, status)
        resource = Api::V1::FileResource.new(file, nil)
        render json: serializer.serialize_to_hash(resource), status: status
      end

      def included_tags
        filter_params[:tag_search_query]
          .split(' ')
          .select { |tag| /^\+/.match(tag) }
          .collect { |tag| tag[1..tag.size - 1] }
      end

      def excluded_tags
        filter_params[:tag_search_query]
          .split(' ')
          .select { |tag| /^\-/.match(tag) }
          .collect { |tag| tag[1..tag.size - 1] }
      end

      def query_tags
        included_tags + excluded_tags
      end

      def get_all_related_tags(files)
        files
          .map(&:tags)
          .flatten
          .uniq
          .reject { |tag| query_tags.include?(tag) }
      end

      def serializer
        JSONAPI::ResourceSerializer.new(Api::V1::FileResource)
      end
    end
  end
end
