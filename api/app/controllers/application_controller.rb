# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include PaginationConcern
  include SentryConcern
  include RescueConcern
  include Solipsist

  serialization_scope :serializer_context

  cognito_authentication user_class: 'User'

  # def current_user
  #   @current_user ||= User.find_by(auth_id: request.headers['x-auth-id'])
  # end

  def render_errors(errors, status: :unprocessable_entity)
    render json: { errors:, message: errors.full_messages.to_sentence, details: errors.details }, status:
  end

  def serializer_context
    @serializer_context ||= OpenStruct.new(params:, current_user:)
  end

  def render_import_errors(errors, status: :unprocessable_entity)
    render json: { errors: }, status:
  end
end
