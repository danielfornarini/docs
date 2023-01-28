# frozen_string_literal: true

if defined?(DatabaseCleaner)
  RSpec.configure do |config|
    config.use_transactional_fixtures = false if config.respond_to?(:use_transactional_fixtures=)

    orms = [
      DatabaseCleaner[:active_record]
    ]

    orms.each do |orm|
      config.before(:suite) do
        orm.clean_with(:truncation)
      end

      config.before(:each) do
        orm.strategy = :transaction
      end

      config.before(:each, transactions: true) do
        orm.strategy = :truncation
      end

      config.before(:each) do
        orm.start
      end

      config.after(:each) do
        orm.clean
      end

      config.after(:all) do
        orm.clean_with(:truncation)
      end
    end
  end
end
