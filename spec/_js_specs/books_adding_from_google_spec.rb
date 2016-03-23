# Honestly I have no idea why this test needs to be first, but when it was placed
# inside features specs it was failing. When moved here (so it is executed first)
# the test is successfully passing

require 'rails_helper'

RSpec.describe BooksController, type: :feature do
  it 'User should add book from Google', js: true do
    Warden.test_mode!

    user = FactoryGirl.create :user
    login_as user, scope: :user, run_callbacks: false

    visit new_book_path

    fill_in 'isbn', with: 'Search phrase'
    click_button 'Search'

    wait_for_ajax

    expect(page).to have_selector('div.search-row', count: 10)

    first("input[name='add_from_search']").click

    wait_for_ajax

    expect(page).to have_content('Item has been successfully added')

    books = Book.all

    expect(books.count).to eq 1

    # Values from spec/fixtures/google_response.json
    expect(books.first.name).to eq 'Java and XML'
    expect(books.first.author).to eq 'Brett McLaughlin, Justin Edelson'
    expect(books.first.isbn).to eq '9780596515416'
  end
end
