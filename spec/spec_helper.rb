require 'bundler/setup'
Bundler.setup

require 'octokit'
require 'base64'
require 'opt_client'

@@pid = ''

RSpec.configure do |config|
  config.before(:all) do
    api_response = Octokit.contents 'stopanko/test_api', :path => 'app.rb'
    text_contents = "require 'sinatra'
                      require 'data_mapper'
                      require 'json'
                      require 'sinatra/contrib'
                      require 'dm-migrations'
                      require 'dm-sqlite-adapter' \n"
    text_contents += Base64.decode64( api_response.content )
    File.open( './server/app.rb', 'wb' ) { |file| file.puts text_contents }

    api_response = Octokit.contents 'stopanko/test_api', :path => 'config.ru'
    text_contents = Base64.decode64( api_response.content )
    File.open( 'server/config.ru', 'wb' ) { |file| file.puts text_contents }

    Dir.chdir('./server'){
      @@pid = Process.spawn({}, "rackup -E test", :out => 'dev/null', :err => 'dev/null')
      # Process.detach @@pid
    }
    # Sinatra::Application
  end

  config.after (:all) do
    p '@@pid'
    p @@pid
    Process.detach @@pid
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

end
