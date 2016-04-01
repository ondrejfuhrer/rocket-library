require 'rails_helper'

RSpec.describe Rental do
  context '.after_create' do
    it 'set book as rented' do
      book = FactoryGirl.build :book
      user = FactoryGirl.build :user

      Rental.create book: book, user: user

      book.reload

      expect(book.state).to eq 'rented'
    end

    it 'fulfills the users watchlist' do
      book = FactoryGirl.build :book
      user = FactoryGirl.build :user

      rental_user = FactoryGirl.build :user
      current_rental = Rental.create book: book, user: rental_user

      watch_list = WatchList.create rental: current_rental, user: user

      current_rental.return
      book.reload

      Rental.create book: book, user: user

      watch_list.reload

      expect(watch_list.state).to eq 'fulfilled'
    end

    it 'sends email about unfulfilled watchlist' do
      book = FactoryGirl.build :book
      user = FactoryGirl.build :user

      rental_user = FactoryGirl.build :user
      current_rental = Rental.create book: book, user: rental_user

      WatchList.create rental: current_rental, user: user

      current_rental.return

      # we remove all previously generated email
      ActionMailer::Base.deliveries.clear

      book.reload
      Rental.create book: book, user: rental_user

      expect(ActionMailer::Base.deliveries.count).to eq 1
      expect(ActionMailer::Base.deliveries.first.to).to eq [user.email]
      expect(ActionMailer::Base.deliveries.first.subject).to eq "Book [#{book.name}] from your watchlist has been rented again!"
    end

  end
end
