require 'rails_helper'

RSpec.describe 'Books Controller', type: :feature do
  it 'Index page should be secured by login' do
    visit books_path

    expect(page.status_code).to eq 200
    expect(page).to have_field('Email')
    expect(page).to have_field('Password')
  end

  it 'Show page should be secured by login' do
    book = FactoryGirl.create :book
    visit book_path(book)

    expect(page.status_code).to eq 200
    expect(page).to have_field('Email')
    expect(page).to have_field('Password')
  end

  it 'Edit page should be secured by login' do
    book = FactoryGirl.create :book
    visit edit_book_path(book)

    expect(page.status_code).to eq 200
    expect(page).to have_field('Email')
    expect(page).to have_field('Password')
  end

  it 'Index page should be visible after login' do
    user = FactoryGirl.create :user
    login_user user

    visit books_path

    expect(page.status_code).to eq 200
    # We didn't add any books so we except the message to show up
    # Looking for 'Books' is too general since it is also in the navigation bar
    expect(page).to have_content('No Books found')
  end

  it 'Show page should be visible after login' do
    user = FactoryGirl.create :user
    book = FactoryGirl.create :book

    login_user user

    visit book_path(book)

    expect(page.status_code).to eq 200
    expect(page).to have_content(book.name)
  end

  it 'User should not edit book from someone else' do
    user = FactoryGirl.create :user
    book = FactoryGirl.create :book

    login_user user

    expect { visit(edit_book_path(book)) }.to raise_error(CanCan::AccessDenied)
  end

  it 'User should get edit for his book' do
    user = FactoryGirl.create :user
    book = FactoryGirl.create :book, user: user

    login_user user

    visit edit_book_path(book)

    expect(page.status_code).to eq 200
    expect(page).to have_content('Editing Book')
    expect(page).to have_field('Name', with: book.name)
  end

  def login_user(user)
    visit root_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'
  end
end