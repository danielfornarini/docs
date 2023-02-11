class V1::UsersController < ApplicationController
  load_and_authorize_resource

  def update
    default! @user
  end

  def destroy
    default! @user
  end

  def me
    render_default! current_user
  end

  private

  def update_params
    params.permit(
      :first_name,
      :last_name,
      :password,
      :password_confirmation,
      :profile_image,
      :email
    )
  end
end
