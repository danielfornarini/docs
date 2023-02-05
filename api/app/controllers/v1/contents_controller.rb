class V1::ContentsController < ApplicationController
  load_and_authorize_resource

  def show
    default! @content
  end

  def update
    default! @content
  end

  private

  def update_params
    params.permit(:text)
  end
end
