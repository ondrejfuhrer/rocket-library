require 'rails_helper'

RSpec.describe WatchListsController do
  context '#create' do
    it 'should create a new watchlist', js: true do
      Warden.test_mode!

      user = FactoryGirl.create :user
      user2 = FactoryGirl.create :user
      book = FactoryGirl.create :book, sku: 'test-sku'
      rental = Rental.create user: user2, book: book

      login_as user, scope: :user, run_callbacks: false

      visit books_path

      expect(page.status_code).to eq 200

      click_link "watch-list-#{book.id}"

      wait_for_ajax

      watch_lists = WatchList.find_by user: user

      # there should be only one, so it returns the instance
      expect(watch_lists).to be_an_instance_of WatchList
      expect(watch_lists.rental).to eq rental
    end
  end
end
