# frozen_string_literal: true

module SentryConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_sentry_context
  end

  private

  def set_sentry_context
    return unless defined?(Sentry)

    Sentry.set_user(current_user&.email)
    Sentry.set_extras(params: params.to_unsafe_h, url: request.url)
  end
end
