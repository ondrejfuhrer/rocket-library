require 'rails_helper'

RSpec.describe Ability do
  it 'for regular user' do
    user = FactoryGirl.build :user, role: :user
    user2 = FactoryGirl.build :user, role: :user

    users_book = FactoryGirl.build :book, user: user
    other_book = FactoryGirl.build :book, user: user2
    book_without_user = FactoryGirl.build :book, user: nil

    rental = Rental.new book: users_book, user: user
    other_rental = Rental.new book: book_without_user, user: user2

    ability = Ability.new user

    expect(ability).not_to be_able_to(:access, :rails_admin)
    expect(ability).not_to be_able_to(:edit, other_book)
    expect(ability).not_to be_able_to(:edit, book_without_user)
    expect(ability).not_to be_able_to(:destroy, other_rental)
    expect(ability).not_to be_able_to(:manage, other_book)
    expect(ability).not_to be_able_to(:manage, book_without_user)
    expect(ability).not_to be_able_to(:manage, Rental)
    expect(ability).not_to be_able_to(:access, :reports)

    # Books
    expect(ability).to be_able_to(:read, Book)
    expect(ability).to be_able_to(:new, Book)
    expect(ability).to be_able_to(:create, Book)
    expect(ability).to be_able_to(:edit, users_book)
    expect(ability).to be_able_to(:show, users_book)
    expect(ability).to be_able_to(:show, other_book)
    expect(ability).to be_able_to(:show, book_without_user)

    # Rentals
    expect(ability).to be_able_to(:create, Rental)
    expect(ability).to be_able_to(:new, Rental)
    expect(ability).to be_able_to(:destroy, rental)

    # WatchList
    expect(ability).to be_able_to(:create, WatchList)
  end

  it 'for user with manager rights' do
    user = FactoryGirl.build :user, role: :manager
    user2 = FactoryGirl.build :user, role: :user

    users_book = FactoryGirl.build :book, user: user
    other_book = FactoryGirl.build :book, user: user2
    book_without_user = FactoryGirl.build :book, user: nil

    rental = Rental.new book: users_book, user: user
    other_rental = Rental.new book: book_without_user, user: user2

    ability = Ability.new user

    expect(ability).not_to be_able_to(:access, :rails_admin)
    expect(ability).not_to be_able_to(:destroy, other_rental)
    expect(ability).not_to be_able_to(:manage, Rental)

    # Books
    expect(ability).to be_able_to(:read, Book)
    expect(ability).to be_able_to(:new, Book)
    expect(ability).to be_able_to(:create, Book)
    expect(ability).to be_able_to(:edit, users_book)
    expect(ability).to be_able_to(:show, users_book)
    expect(ability).to be_able_to(:show, other_book)
    expect(ability).to be_able_to(:show, book_without_user)
    expect(ability).to be_able_to(:edit, other_book)
    expect(ability).to be_able_to(:edit, book_without_user)
    expect(ability).to be_able_to(:manage, other_book)
    expect(ability).to be_able_to(:manage, book_without_user)

    # Rentals
    expect(ability).to be_able_to(:create, Rental)
    expect(ability).to be_able_to(:new, Rental)
    expect(ability).to be_able_to(:destroy, rental)

    # WatchList
    expect(ability).to be_able_to(:create, WatchList)

    expect(ability).to be_able_to(:access, :reports)
  end

  it 'for admin' do
    user = FactoryGirl.build :user, role: :admin
    user2 = FactoryGirl.build :user, role: :user

    users_book = FactoryGirl.build :book, user: user
    other_book = FactoryGirl.build :book, user: user2
    book_without_user = FactoryGirl.build :book, user: nil

    rental = Rental.new book: users_book, user: user
    other_rental = Rental.new book: book_without_user, user: user2

    ability = Ability.new user

    expect(ability).to be_able_to(:access, :rails_admin)
    expect(ability).to be_able_to(:destroy, other_rental)
    expect(ability).to be_able_to(:manage, Rental)

    # Books
    expect(ability).to be_able_to(:read, Book)
    expect(ability).to be_able_to(:new, Book)
    expect(ability).to be_able_to(:create, Book)
    expect(ability).to be_able_to(:edit, users_book)
    expect(ability).to be_able_to(:show, users_book)
    expect(ability).to be_able_to(:show, other_book)
    expect(ability).to be_able_to(:show, book_without_user)
    expect(ability).to be_able_to(:edit, other_book)
    expect(ability).to be_able_to(:edit, book_without_user)
    expect(ability).to be_able_to(:manage, other_book)
    expect(ability).to be_able_to(:manage, book_without_user)

    # Rentals
    expect(ability).to be_able_to(:create, Rental)
    expect(ability).to be_able_to(:new, Rental)
    expect(ability).to be_able_to(:destroy, rental)

    # WatchList
    expect(ability).to be_able_to(:create, WatchList)

    expect(ability).to be_able_to(:manage, :all)
    expect(ability).to be_able_to(:access, :reports)
  end

end
