require 'rails_helper'

RSpec.describe RentalsController do
  it 'should not access new rental page when not logged in' do
    visit new_rental_path

    expect(page.status_code).to eq 200
    expect(page).to have_field('Email')
    expect(page).to have_field('Password')
  end

  it 'should create new rental page from new rental page' do
    Warden.test_mode!

    user = FactoryGirl.create :user
    book = FactoryGirl.create :book, sku: 'test-sku'

    login_as user, scope: :user, run_callbacks: false

    visit new_rental_path

    expect(page.status_code).to eq 200
    expect(page).to have_field('Sku')

    fill_in 'Sku', with: book.sku
    click_button 'Rent this book'

    expect(page.status_code).to eq 200
    expect(page).to have_content "Book [#{book.name}] has been successfully rented"
    expect(user.rentals.count).to eq 1
    expect(user.rentals.first.book).to eq book
  end

  it 'should not create new rental page from new rental page without sku' do
    Warden.test_mode!

    user = FactoryGirl.create :user
    FactoryGirl.create :book, sku: 'test-sku'

    login_as user, scope: :user, run_callbacks: false

    visit new_rental_path

    expect(page.status_code).to eq 200
    expect(page).to have_field('Sku')

    click_button 'Rent this book'

    expect(page.status_code).to eq 200
    expect(page).to have_content 'You must provide an SKU to rent a book'
    expect(user.rentals.count).to eq 0
  end

  it 'should not create new rental from new rental page with wrong sku' do
    Warden.test_mode!

    user = FactoryGirl.create :user
    FactoryGirl.create :book, sku: 'test-sku'

    login_as user, scope: :user, run_callbacks: false

    visit new_rental_path

    expect(page.status_code).to eq 200
    expect(page).to have_field('Sku')

    fill_in 'Sku', with: 'some invalid sku'
    click_button 'Rent this book'

    expect(page.status_code).to eq 200
    expect(page).to have_content 'Book with given SKU [some invalid sku] was not found.'
    expect(user.rentals.count).to eq 0
  end

  it 'should not create new rental from new rental page on already rented book' do
    Warden.test_mode!

    user = FactoryGirl.create :user
    user2 = FactoryGirl.create :user
    book = FactoryGirl.create :book, sku: 'test-sku'

    login_as user, scope: :user, run_callbacks: false

    visit new_rental_path

    expect(page.status_code).to eq 200
    expect(page).to have_field('Sku')

    Rental.create book: book, user: user2

    fill_in 'Sku', with: book.sku
    click_button 'Rent this book'

    expect(page.status_code).to eq 200
    expect(page).to have_content 'Book with SKU [test-sku] has been already rented'
    expect(user.rentals.count).to eq 0
  end

  it 'should create new rental page from books page', js: true do
    Warden.test_mode!

    user = FactoryGirl.create :user
    book = FactoryGirl.create :book, sku: 'test-sku'

    login_as user, scope: :user, run_callbacks: false

    visit books_path

    expect(page.status_code).to eq 200

    click_link 'Rent'

    wait_for_ajax

    expect(user.rentals.count).to eq 1
    expect(user.rentals.first.book).to eq book

    expect(page).to have_content 'Return'
  end

  it 'should return book from books page', js: true do
    Warden.test_mode!

    user = FactoryGirl.create :user
    book = FactoryGirl.create :book, sku: 'test-sku'
    Rental.create user: user, book: book

    login_as user, scope: :user, run_callbacks: false

    visit books_path

    expect(page.status_code).to eq 200

    click_link 'Return'

    return_message = 'This is optional return message'

    fill_in 'return_message', with: return_message

    click_button 'Return Book'

    wait_for_ajax

    expect(page).to have_content 'Rent'

    expect(user.rentals.count).to eq 1
    expect(user.rentals.first.returned?).to be true
    expect(user.rentals.first.book).to eq book
    expect(user.rentals.first.return_message).to eq return_message
  end

  it 'should return book from account page', js: true do
    Warden.test_mode!

    user = FactoryGirl.create :user
    book = FactoryGirl.create :book, sku: 'test-sku'
    Rental.create user: user, book: book

    login_as user, scope: :user, run_callbacks: false

    visit root_path

    expect(page.status_code).to eq 200

    click_link 'Return'

    return_message = 'This is optional return message'

    fill_in 'return_message', with: return_message

    click_button 'Return Book'

    expect(page).to have_content 'Rent'
    expect(page).to have_content 'Book was successfully returned'

    expect(user.rentals.count).to eq 1
    expect(user.rentals.first.returned?).to be true
    expect(user.rentals.first.book).to eq book
    expect(user.rentals.first.return_message).to eq return_message
  end

end
