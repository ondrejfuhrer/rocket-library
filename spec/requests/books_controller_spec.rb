require 'rails_helper'

RSpec.describe 'Books Controller', type: :request do
  it 'Index page should be secured by login' do
    visit books_path
    page.should have_field('Email')
    page.should have_field('Password')
  end
end