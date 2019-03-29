# frozen_string_literal: true

module Api
  module V1
    class FilesController < APIController # :nodoc:
      include FilterTagsHelper

      def index
        files = CustomFile.filter_by_tags(included_tags: included_tags,
                                          excluded_tags: excluded_tags,
                                          page: params[:page])
        meta = { meta: meta_params(files) }
        render_response(files, 'CustomFile', :ok, meta)
      end

      def create
        file = CustomFile.create!(file_params)
        render_response(file, 'File', :ok)
      end

      private

      def file_params
        params.require(:data).require(:attributes).permit(:name, tags: [])
      end

      def filter_params
        params.permit(:tag_search_query, :page, :format, file: {})
      end

      def meta_params(files)
        related_tags = get_all_related_tags(files)
        {
          total_records: files.size,
          related_tags: related_tags.map do |tag|
            {
              tag: tag,
              file_count: files.where('tags @> ARRAY[?]::text[]', [tag]).count
            }
          end
        }
      end
    end
  end
end
