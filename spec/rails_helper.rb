ENV['COVERAGE_REPORTS'] ||= 'tmp/coverage'
ENV['CI_REPORTS'] ||= 'tmp/testresults'
ENV['CI_COVERAGE_FORMATTER'] ||= 'html'

if ENV['CIRCLE_ARTIFACTS']
  dir = File.join(ENV['CIRCLE_ARTIFACTS'], 'coverage')
  SimpleCov.coverage_dir(dir)
else
  SimpleCov.coverage_dir(ENV['COVERAGE_REPORTS'])
end

case ENV['CI_COVERAGE_FORMATTER']
  when 'csv'
    require 'simplecov-csv'
    SimpleCov.formatter = SimpleCov::Formatter::CSVFormatter
  else
    require 'simplecov-html'
    SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
end

SimpleCov.start 'rails'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

MiniTest::Reporters.use! [
                           MiniTest::Reporters::DefaultReporter.new,
                           MiniTest::Reporters::JUnitReporter.new(ENV['CI_REPORTS'])
                         ]

require 'spec_helper'
require 'rspec/rails'

# Add additional requires below this line. Rails is not loaded until this point!
require 'ffaker'
require 'cancan/matchers'
require 'capybara/webkit/matchers'
require 'minitest/reporters'
require 'support/shared_db_connection'
require 'devise'

WebMock.stub_request(:any, /.*googleapis.*/).to_return(:status => 200, :body => File.read("#{::Rails.root}/spec/fixtures/google_response.json"), :headers => {})
WebMock.stub_request(:any, /.*avatar.google.com.*/).to_return(:status => 200, :body => File.read("#{::Rails.root}/app/assets/images/cover_placeholder_small.jpg"), :headers => {})

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  config.include FactoryGirl::Syntax::Methods

  config.include Devise::TestHelpers, :type => :controller
end
