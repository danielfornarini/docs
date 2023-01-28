# frozen_string_literal: true

module PaginationConcern
  extend ActiveSupport::Concern

  protected

  def page_params
    @page_params ||= {
      number: params[:page] || 1,
      size: params[:per] || 25
    }
  end

  def pagination_meta(list)
    return nil unless list.respond_to?(:current_page)

    {
      current_page: list.current_page,
      last_page: list.total_pages,
      total_rows: list.total_count,
      next_page: list.next_page,
      previous_page: list.prev_page,
      total_pages: list.total_pages,
      per_page: list.limit_value
    }
  end
end
