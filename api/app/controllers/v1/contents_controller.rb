class V1::ContentsController < ApplicationController
  load_and_authorize_resource except: [:versions]

  def show
    default! @content
  end

  def update
    default! @content
  end

  def versions
    @content = Content.find(params[:id])
    authorize! :read, @content
    render_default! @content.versions, each_serializer: ContentVersionSerializer
  end

  private

  def update_params
    params.permit(:text)
  end
end
