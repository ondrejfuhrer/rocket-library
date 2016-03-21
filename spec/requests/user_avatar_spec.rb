require 'rails_helper'

RSpec.describe User do
  it 'should display google avatar' do
    Warden.test_mode!
    user = FactoryGirl.create :user, google_avatar_url: 'http://avatar.google.com/whatever'

    login_as user, scope: :user, run_callbacks: false

    visit root_path

    expect(page.find('img.user-avatar')['src']).to eq 'http://avatar.google.com/whatever?sz=30'
  end

  it 'should display gravatar' do
    Warden.test_mode!
    user = FactoryGirl.create :user, email: 'statically-created-email@test.com'

    login_as user, scope: :user, run_callbacks: false

    visit root_path

    expect(page.find('img.user-avatar')['src']).to eq 'http://www.gravatar.com/avatar/cc7afd3bfc63e4f91c02f9db66cae163?s=30'
  end

  it 'should display user full name' do
    user = FactoryGirl.create :user

    login_as user, scope: :user, run_callbacks: false

    visit root_path

    expect(page.find('span.user-name')).to have_content "#{user.first_name} #{user.last_name}"
  end

  it 'should display user email' do
    user = FactoryGirl.create :user, first_name: '', last_name: ''

    login_as user, scope: :user, run_callbacks: false

    visit root_path

    expect(page.find('span.user-name')).to have_content user.email
  end
end
