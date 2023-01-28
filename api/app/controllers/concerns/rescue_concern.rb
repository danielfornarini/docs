# frozen_string_literal: true

module RescueConcern
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/BlockLength
  included do
    rescue_from CanCan::AccessDenied do |exception|
      debug_text = "Access denied on #{exception.action} #{exception.subject}"\
                   " for `#{current_user&.email}` at #{request.url}"
      Rails.logger.debug debug_text
      if Rails.env.test?
        _handle_error_message(debug_text, status: :forbidden)
      else
        _handle_error_message('You have no permission to access this area.', status: :forbidden)
      end
    end

    if Rails.env.test?
      rescue_from ActiveRecord::RecordNotFound do
        head :not_found
      end

      rescue_from ActionController::ParameterMissing do |error|
        _handle_error_message(
          error.message,
          status: :unprocessable_entity
        )
      end
    end

    rescue_from ActiveRecord::InvalidForeignKey do |error|
      Sentry.capture_exception(error) if defined?(Sentry)
      Rails.logger.error(error)

      _handle_error_message(
        'Invalid foreign key.',
        status: :not_found
      )
    end

    rescue_from ActiveRecord::DeleteRestrictionError do |error|
      Sentry.capture_exception(error) if defined?(Sentry)
      Rails.logger.error(error)

      _handle_error_message(
        'Failed to destroy. Some data depends from this record.',
        status: :unprocessable_entity
      )
    end

    rescue_from ActiveRecord::RecordNotUnique do |error|
      Sentry.capture_exception(error) if defined?(Sentry)

      _handle_error_message('Duplicate record.', status: :unprocessable_entity)
    end

    rescue_from ActionController::InvalidAuthenticityToken do
      _handle_error_message('Session expired.', status: :unauthorized)
    end

    protected

    def _handle_error_message(message, status: nil)
      respond_to do |format|
        format.json do
          render json: { errors: { status: [status] }, message: }, status:
        end
        format.html do
          render html: "<div>#{status.to_s.humanize}</div>", status:
        end
      end
    end
  end
  # rubocop:enable Metrics/BlockLength
end
