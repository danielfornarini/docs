# frozen_string_literal: true

module ApplicationCable
  class Channel < ActionCable::Channel::Base
    delegate :ability, to: :connection
    delegate :current_user, to: :connection

    def transmit(*args)
      super(render_json(*args))
    end

    def broadcast_to(model, *args)
      super(model, render_json(*args))
    end

    def render_json(data, options = {})
      self.class.render_json(data, { serializer_context: }.merge!(options))
    end

    def serializer_context
      @serializer_context ||= OpenStruct.new(params:, current_user:)
    end

    class << self
      def broadcast_to(model, *args)
        super(model, render_json(*args))
      end

      def render_json(data, options = {})
        ActiveModelSerializers::SerializableResource.new(
          data,
          options
        ).as_json
      end
    end
  end
end
