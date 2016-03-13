require 'bundler/setup'
Bundler.setup

require 'opt_client'

RSpec.configure do |config|
  config.before(:all) do
    instrument = OptClient.init_api(host: 'http://localhost:9292')
    instrument.clean
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

end
