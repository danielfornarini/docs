# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    define_authenticated_abilities!(user) if user
  end

  private

  def define_authenticated_abilities!(user)
    can :manage, User, id: user.id
  end
end
