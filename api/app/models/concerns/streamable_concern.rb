# frozen_string_literal: true

module StreamableConcern
  extend ActiveSupport::Concern

  included do
    after_commit :notify_stream_create!, on: :create
    after_commit :notify_stream_update!, on: :update
    after_commit :notify_stream_destroy!, on: :destroy

    delegate :stream_options, to: :class
  end

  class_methods do
    def stream_to(channel_name, through: nil, options: {})
      stream_options[:channel_name] = channel_name
      stream_options[:through] = through
      stream_options[:options] = options
    end

    def stream_options
      @stream_options ||= {
        channel_name: name.underscore.pluralize
      }
    end

    def channel_name
      stream_options[:channel_name]
    end
  end

  def notify_stream_create!
    CableJob.perform_later(self, :create, stream_options[:options])
  end

  def notify_stream_update!
    CableJob.perform_later(self, :update, stream_options[:options], previous_changes)
  end

  def notify_stream_destroy!
    CableJob.perform_now(self, :destroy, stream_options[:options])
  end
end
