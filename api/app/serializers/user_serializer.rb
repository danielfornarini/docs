class UserSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers

  attributes :first_name, :last_name, :email, :profile_image

  def profile_image
    rails_blob_url(object.profile_image) if object.profile_image.attached?
  end
end
