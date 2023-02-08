class V1::DocumentsController < ApplicationController
  load_and_authorize_resource

  def index
    @documents = @documents.query_by(params)
    render_default! @documents, meta: pagination_meta(@documents)
  end

  def show
    default! @document
  end

  def create
    default! @document
  end

  def update
    default! @document
  end

  def destroy
    default! @document
  end

  private

  def create_params
    params.permit(:title).merge({ owner_id: current_user.id })
  end

  def update_params
    params.permit(:title)
  end
end
