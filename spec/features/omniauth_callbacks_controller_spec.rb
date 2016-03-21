require 'rails_helper'

RSpec.describe OmniauthCallbacksController do
  context '#google_oauth2' do
    it 'should register and login new user' do
      OmniAuth.config.test_mode = true
      omniauth_data = OmniAuth::AuthHash.new
      omniauth_data.info = {
        :email.to_s => FFaker::Internet.email,
        :first_name.to_s => FFaker::Name.first_name,
        :last_name.to_s => FFaker::Name.last_name,
        :image.to_s => FFaker::Internet.http_url,
      }
      OmniAuth.config.mock_auth[:google_oauth2] = omniauth_data

      visit root_path

      click_link 'google-login-link'

      expect(page).to have_content('Successfully authenticated from Google account.')

      users = User.all
      expect(users.count).to eq 1
      expect(users.first.email).to eq omniauth_data.info[:email]
      expect(users.first.first_name).to eq omniauth_data.info[:first_name]
      expect(users.first.last_name).to eq omniauth_data.info[:last_name]
    end

    it 'should login existing user' do

      user = FactoryGirl.create :user

      OmniAuth.config.test_mode = true
      omniauth_data = OmniAuth::AuthHash.new
      omniauth_data.info = {
        :email.to_s => user.email,
        :first_name.to_s => user.first_name,
        :last_name.to_s => user.last_name,
        :image.to_s => user.google_avatar_url,
      }
      OmniAuth.config.mock_auth[:google_oauth2] = omniauth_data

      visit root_path

      click_link 'google-login-link'

      expect(page).to have_content('Successfully authenticated from Google account.')

      users = User.all
      expect(users.count).to eq 1
      expect(users.first).to eq user
    end
  end
end
