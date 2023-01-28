# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, Article

    define_authenticated_abilities!(user) if user
  end

  def define_authenticated_abilities!(user)
    can :manage, Chat
    can %i[read create], Message
    can :manage, Message, user_id: user.id

    can :read, Comment
    can :manage, Comment, user_id: user.id
  end
end
