class ContentVersionSerializer < ApplicationSerializer
  type 'contentVersions'

  attributes :content, :created_at

  belongs_to :user

  def content
    object.object
  end

  def user
    User.find(object.whodunnit) if object.whodunnit
  end
end
