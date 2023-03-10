# frozen_string_literal: true

module Requests
  module JsonHelpers
    def invalidate_json!
      @json = nil
    end

    def json
      @json ||= JSON.parse(response.body)
    end
  end
end

RSpec.configure do |config|
  config.include Requests::JsonHelpers, type: :request
end
