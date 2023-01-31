# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include PaginationConcern
  include SentryConcern
  include RescueConcern
  include Solipsist
  include UnderscorizeParamsConcern

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, unless: :auth_controller?

  serialization_scope :serializer_context
  respond_to :json

  def render_errors(errors, status: :unprocessable_entity)
    render json: { errors:, message: errors.full_messages.to_sentence, details: errors.details }, status:
  end

  def serializer_context
    @serializer_context ||= OpenStruct.new(params:, current_user:)
  end

  def render_import_errors(errors, status: :unprocessable_entity)
    render json: { errors: }, status:
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :password, :password_confirmation])
  end

  def auth_controller?
    devise_controller? || is_a?(V1::Auth::PasswordsController)
  end
end
