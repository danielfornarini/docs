class DocumentSerializer < ApplicationSerializer
  attributes :title, :content_id, :created_at, :updated_at

  belongs_to :owner, serializer: UserSerializer

  def content_id
    object.content.id
  end
end
