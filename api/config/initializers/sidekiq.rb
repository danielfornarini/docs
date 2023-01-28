# frozen_string_literal: true

redis_url = Rails.env.production? ? "redis://#{ENV.fetch('REDIS_ENDPOINT')}" : 'redis://localhost:6379/0'

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
  config.logger.level = Logger::INFO
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
