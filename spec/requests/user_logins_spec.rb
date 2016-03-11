require 'rails_helper'

describe 'User Logins', type: :feature do

  it 'should get login page' do
    visit root_path
    expect(page).to have_field('Email')
    expect(page).to have_field('Password')
  end

  it 'user can login with credentials' do
    user = FactoryGirl.create :user

    visit root_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'

    expect(page.status_code).to eq 200
    expect(page.current_path).to eq '/'
    expect(page).to have_content 'Dashboard'
  end
end
