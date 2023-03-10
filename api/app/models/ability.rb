# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    define_authenticated_abilities!(user) if user
  end

  private

  def define_authenticated_abilities!(user)
    can :manage, User, id: user.id

    define_document_abilities! user
    define_content_abilities! user
  end

  def define_document_abilities!(user)
    can :create, Document
    can :read, Document, id: Document.of_reader_user_id(user.id).pluck(:id)
    can :update, Document, id: Document.of_writer_user_id(user.id).pluck(:id)
    can :destroy, Document, owner_id: user.id
  end

  def define_content_abilities!(user)
    can :read, Content, id: Content.of_reader_user_id(user.id).pluck(:id)
    can :update, Content, id: Content.of_writer_user_id(user.id).pluck(:id)
  end
end
