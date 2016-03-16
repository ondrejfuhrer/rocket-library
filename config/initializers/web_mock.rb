if ENV['RAILS_ENV'] == 'test'
  WebMock.disable_net_connect!(allow_localhost: true)
  WebMock.stub_request(:any, /.*googleapis.*/).to_return(:status => 200, :body => File.read("#{::Rails.root}/spec/fixtures/google_response.json"), :headers => {})
end
