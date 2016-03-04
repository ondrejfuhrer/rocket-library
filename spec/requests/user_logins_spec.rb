require 'rails_helper'

RSpec.describe 'UserLogins', type: :request do
  it 'should get login page' do
    visit root_path
    page.should have_field('Email')
    page.should have_field('Password')
  end

  it 'user can login with credentials' do
    user = create(:user)
    visit root_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  it 'try something' do
    visit books_path
  end
end
