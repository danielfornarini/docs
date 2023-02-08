# frozen_string_literal: true

module UnderscorizeParamsConcern
  extend ActiveSupport::Concern

  included { before_action :underscore_params! }

  private

  def underscore_params!
    params
      .instance_variable_get(:@parameters)
      .deep_transform_keys!(&:underscore)
  end
end
