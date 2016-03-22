require 'rails_helper'

RSpec.describe RailsAdmin do

  it 'should be accessed by admin' do
    Warden.test_mode!
    user = FactoryGirl.create :user, role: :admin

    login_as user, scope: :user, run_callbacks: false

    visit rails_admin_path

    expect(page.status_code).to eq 200
  end

  it 'should not be accessed by manager' do
    Warden.test_mode!
    user = FactoryGirl.create :user, role: :manager

    login_as user, scope: :user, run_callbacks: false

    expect { visit rails_admin_path }.to raise_error(CanCan::AccessDenied)
  end

  it 'should not be accessed by user' do
    Warden.test_mode!
    user = FactoryGirl.create :user, role: :user

    login_as user, scope: :user, run_callbacks: false

    expect { visit rails_admin_path }.to raise_error(CanCan::AccessDenied)
  end
end
