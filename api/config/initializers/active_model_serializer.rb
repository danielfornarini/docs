# frozen_string_literal: true

ActiveModelSerializers.config.adapter = ActiveModelSerializers::Adapter::JsonApi
ActiveModel::Serializer.config.key_transform = :camel_lower
