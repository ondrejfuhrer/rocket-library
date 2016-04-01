require 'rails_helper'

RSpec.describe UserMailer do
  context '#watchlist' do
    let(:user) { FactoryGirl.create :user }
    let(:book) { FactoryGirl.create :book }
    let(:rental) { Rental.create book: book, user: user }
    let(:mail) { UserMailer.watchlist(user, rental) }

    it 'renders the subject' do
      expect(mail.subject).to eq("Book [#{book.name}] from your watchlist has been returned")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['info@rocket-library.com'])
    end

    it 'assigns @user' do
      expect(mail.body.encoded).to match(user.full_name)
    end

    it 'assigns @book' do
      expect(mail.body.encoded).to match(book.name)
    end
  end

  context '#watchlist_unfulfilled' do
    let(:user) { FactoryGirl.create :user }
    let(:book) { FactoryGirl.create :book }
    let(:rental) { Rental.create book: book, user: user }
    let(:mail) { UserMailer.watchlist_unfulfilled(user, rental) }

    it 'renders the subject' do
      expect(mail.subject).to eq("Book [#{book.name}] from your watchlist has been rented again!")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['info@rocket-library.com'])
    end

    it 'assigns @user' do
      expect(mail.body.encoded).to match(user.full_name)
    end

    it 'assigns @book' do
      expect(mail.body.encoded).to match(book.name)
    end
  end
end
