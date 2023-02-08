# frozen_string_literal: true

class V1::Auth::PasswordsController < ApplicationController
  def forgot
    user = User.find_by(email: params.require(:email))

    if user.present?
      user.send_reset_password_instructions
      render json: { status: 'ok' }, status: :ok
    else
      render json: { error: ['Email address not found. Please check and try again.'] }, status: :not_found
    end
  end

  def reset
    user = User.find_by(reset_password_token: params[:token].to_s)

    if user.present? && user.password_token_valid?
      user.reset_password!(params.require(:password), params.require(:password_confirmation))
      render json: { status: 'ok' }, status: :ok
    else
      render json: { error: ['Link not valid or expired. Try generating a new link.'] }, status: :not_found
    end
  rescue ActiveRecord::RecordInvalid
    render json: { error: user.errors.full_messages }, status: :unprocessable_entity
  end
end
