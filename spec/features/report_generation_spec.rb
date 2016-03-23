require 'rails_helper'

RSpec.describe 'Reports' do
  it 'should create a new report an download as CSV' do
    Warden.test_mode!

    user = FactoryGirl.create :user, role: :manager
    user2 = FactoryGirl.create :user
    book = FactoryGirl.create :book, sku: 'test-sku'
    book2 = FactoryGirl.create :book
    rental = Rental.create user: user, book: book
    Rental.create user: user2, book: book
    rental2 = Rental.create user: user, book: book2

    rental.return
    rental2.return

    login_as user, scope: :user, run_callbacks: false

    visit reports_index_path

    expect(page.status_code).to eq 200

    fill_in :options_date_from, with: Date.yesterday
    fill_in :options_date_to, with: Date.today

    # We need to fill in the hidden fields by xpath
    first(:xpath, "//input[@id='date_from_hidden']").set Date.yesterday
    first(:xpath, "//input[@id='date_to_hidden']").set Date.today

    click_button 'Generate'

    expect(page.status_code).to eq 200
    expect(page).to have_selector('tr.report-row', count: 2)

    click_link 'CSV'

    expect(page.response_headers['Content-type']).to eq 'text/csv; charset=utf-8'
  end

  it 'should create a new report an download as XLS' do
    Warden.test_mode!

    user = FactoryGirl.create :user, role: :manager
    user2 = FactoryGirl.create :user
    book = FactoryGirl.create :book, sku: 'test-sku'
    book2 = FactoryGirl.create :book
    rental = Rental.create user: user, book: book
    Rental.create user: user2, book: book
    rental2 = Rental.create user: user, book: book2

    rental.return
    rental2.return

    login_as user, scope: :user, run_callbacks: false

    visit reports_index_path

    expect(page.status_code).to eq 200

    fill_in :options_date_from, with: Date.yesterday
    fill_in :options_date_to, with: Date.today

    # We need to fill in the hidden fields by xpath
    first(:xpath, "//input[@id='date_from_hidden']").set Date.yesterday
    first(:xpath, "//input[@id='date_to_hidden']").set Date.today

    click_button 'Generate'

    expect(page.status_code).to eq 200
    expect(page).to have_selector('tr.report-row', count: 2)

    click_link 'XLS'

    expect(page.response_headers['Content-type']).to eq 'application/xls; charset=utf-8'
  end
end
