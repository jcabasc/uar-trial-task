# frozen_string_literal: true

module FilterTagsHelper # :nodoc:
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
end
