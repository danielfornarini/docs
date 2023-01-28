# frozen_string_literal: true

if defined?(Sentry)
  Sentry.init do |config|
    config.dsn = Rails.application.credentials.dig(:sentry, :dsn)
    config.breadcrumbs_logger = %i[sentry_logger http_logger]
    config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
    config.current_environment = ENV.fetch('GLOBAL_ENV', 'staging')
    config.tags = { platform: 'api' }

    # To activate performance monitoring, set one of these options.
    # We recommend adjusting the value in production:
    config.traces_sample_rate = 0.3
  end
end
