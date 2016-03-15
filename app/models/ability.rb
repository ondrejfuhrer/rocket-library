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
    can :create, Book

    can :new, Rental
    can :create, Rental

    # WatchLists
    can :create, WatchList

    # Rentals
    can :destroy, Rental do |r|
      (r.user == user)
    end

    if user.role.manager?
      can :manage, Book
    else
      can :manage, Book do |book|
        (book.user == user)
      end
    end

    can [:read, :update], User do |u|
      (u == user)
    end
  end
end
