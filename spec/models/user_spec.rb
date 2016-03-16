require 'rails_helper'

RSpec.describe User do
  context '#full_name' do
    it 'returns concatenated first and last name' do
      first_name = FFaker::Name.first_name
      last_name = FFaker::Name.last_name
      user = FactoryGirl.build :user, first_name: first_name, last_name: last_name

      expect(user.full_name).to eq "#{first_name} #{last_name}"
    end

    it 'returns first name when last name not present' do
      first_name = FFaker::Name.first_name
      user = FactoryGirl.build :user, first_name: first_name, last_name: nil

      expect(user.full_name).to eq first_name
    end

    it 'returns last name when first name not present' do
      last_name = FFaker::Name.last_name
      user = FactoryGirl.build :user, first_name: nil, last_name: last_name

      expect(user.full_name).to eq last_name
    end
  end

  context '.from_omniauth' do
    it 'returns already created user' do
      saved_user = FactoryGirl.create :user

      omniauth_data = OmniAuth::AuthHash.new
      omniauth_data.info = { :email.to_s => saved_user.email }

      result = User.from_omniauth omniauth_data

      expect(result).to eq saved_user
    end

    it 'creates a new user from given data' do
      omniauth_data = OmniAuth::AuthHash.new
      omniauth_data.info = {
        :email.to_s => FFaker::Internet.email,
        :first_name.to_s => FFaker::Name.first_name,
        :last_name.to_s => FFaker::Name.last_name,
        :image.to_s => FFaker::Internet.http_url,
      }

      result = User.from_omniauth omniauth_data

      expect(result).to be_instance_of(User)
      expect(result.persisted?).to be(true)
      expect(result.first_name).to eq omniauth_data.info['first_name']
      expect(result.last_name).to eq omniauth_data.info['last_name']
      expect(result.email).to eq omniauth_data.info['email']
      expect(result.google_avatar_url).to eq omniauth_data.info['image']
    end

    it 'updates google image url' do
      saved_user = FactoryGirl.create :user, google_avatar_url: FFaker::Internet.http_url

      new_image_url = FFaker::Internet.http_url

      omniauth_data = OmniAuth::AuthHash.new
      omniauth_data.info = { :email.to_s => saved_user.email, :image.to_s => new_image_url }

      result = User.from_omniauth omniauth_data

      expect(result).to eq saved_user
      expect(result.google_avatar_url).to eq(new_image_url)
    end
  end
end
