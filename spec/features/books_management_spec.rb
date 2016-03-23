require 'rails_helper'

RSpec.describe BooksController do
  it 'User should get all books' do
    user = FactoryGirl.create :user
    book = FactoryGirl.create :book, user: user
    book2 = FactoryGirl.create :book, user: user

    login_user user
    visit books_path

    expect(page.status_code).to eq 200
    # We check that both books has been rendered
    expect { page.find_by_id("book-#{book.id}") }.not_to raise_error
    expect { page.find_by_id("book-#{book2.id}") }.not_to raise_error
  end

  it 'User should be able to filter books by alphabet' do
    user = FactoryGirl.create :user
    book = FactoryGirl.create :book, name: 'Alphabet', user: user
    book2 = FactoryGirl.create :book, name: 'Black books', user: user

    filter_letter = book.name[0].downcase

    login_user user
    visit alphabetic_filter_books_path(filter_letter)

    expect(page.status_code).to eq 200
    # We check that only first book has been rendered
    expect { page.find_by_id("book-#{book.id}") }.not_to raise_error
    expect { page.find_by_id("book-#{book2.id}") }.to raise_error(Capybara::ElementNotFound)
  end

  it 'User should be able to add manually a new book' do
    user = FactoryGirl.create :user

    FactoryGirl.create :book

    expect(Book.all.count).to eq 1

    login_user user
    visit new_book_path

    book_name = 'New book name'
    book_author = 'Tester Testovic'
    book_isbn = '4455588645123'

    fill_in 'Name', with: book_name
    fill_in 'Author', with: book_author
    fill_in 'Isbn', with: book_isbn
    attach_file('book_cover', File.absolute_path("#{Rails.root}/app/assets/images/cover_placeholder_big.jpg"))

    click_button 'Save'

    expect(page.status_code).to eq 200

    books = Book.all

    expect(books.count).to eq 2
    expect(books.first.name).to eq book_name
    expect(books.first.author).to eq book_author
    expect(books.first.isbn).to eq book_isbn
    expect(books.first.cover).to be_a BookCoverUploader

  end

  it 'User should not be able to add manually a new book with empty params' do
    user = FactoryGirl.create :user

    login_user user
    visit new_book_path

    click_button 'Save'

    expect(Book.all.count).to eq 0
    expect(page).to have_content('2 errors prohibited this book from being saved')
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Author can't be blank")
  end

  it 'User should be able to edit book' do
    user = FactoryGirl.create :user
    book = FactoryGirl.create :book, user: user

    login_user user
    visit edit_book_path(book)

    book_name = 'New book name'
    book_author = 'Tester Testovic'
    book_isbn = '4455588645123'

    fill_in 'Name', with: book_name
    fill_in 'Author', with: book_author
    fill_in 'Isbn', with: book_isbn

    click_button 'Save'

    books = Book.all

    expect(books.count).to eq 1
    expect(books.first.name).to eq book_name
    expect(books.first.author).to eq book_author
    expect(books.first.isbn).to eq book_isbn

  end

  it 'User should not be able to edit book with empty params' do
    user = FactoryGirl.create :user
    book = FactoryGirl.create :book, user: user

    login_user user
    visit edit_book_path(book)

    fill_in 'Name', with: ''
    fill_in 'Author', with: ''
    fill_in 'Isbn', with: ''

    click_button 'Save'

    books = Book.all

    expect(books.count).to eq 1
    expect(books.first.name).to eq book.name
    expect(books.first.author).to eq book.author
    expect(books.first.isbn).to eq book.isbn

    expect(page).to have_content('2 errors prohibited this book from being saved')
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Author can't be blank")

  end

  it 'User should be able to remove book' do
    user = FactoryGirl.create :user
    book = FactoryGirl.create :book, user: user

    login_user user
    page.driver.submit :delete, book_path(book), {}

    books = Book.all

    expect(books.count).to eq 0

  end

  def login_user(user)
    visit root_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'
  end
end
