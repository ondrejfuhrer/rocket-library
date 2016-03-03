class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    if user.role.admin?
      can :access, :rails_admin
      can :manage, :all
      return
    end

    can :read, Book

    if user.role.manager?
      can :manage, Book
    end

    # Rentals
    can :manage, Rental

    can [:read, :update], User do |u|
      (u == user)
    end
  end
end
