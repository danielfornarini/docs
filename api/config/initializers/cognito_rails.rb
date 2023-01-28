# frozen_string_literal: true

cognito_credentials = Rails.application.credentials&.dig(:cognito)

CognitoRails::Config.aws_access_key_id = cognito_credentials&.dig(:access_key_id) || 'test'
CognitoRails::Config.aws_region = cognito_credentials&.dig(:region) || 'eu-central-1'
CognitoRails::Config.aws_secret_access_key = cognito_credentials&.dig(:secret_access_key) || 'test'
CognitoRails::Config.aws_user_pool_id = cognito_credentials&.dig(:user_pool_id) || 'test'
CognitoRails::Config.default_user_class = 'User'
CognitoRails::Config.skip_model_hooks = Rails.env.test? # To skip cognito user creation during tests
CognitoRails::Config.cache_adapter = Rails.cache
CognitoRails::Config.logger = Rails.logger
