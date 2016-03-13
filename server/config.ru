require 'rubygems'
require 'bundler'
Bundler.require

require './app'

run Sinatra::Application


p 'sinatra_env = Sinatra::Application.environment'
p Sinatra::Application.environment


sinatra_env = Sinatra::Application.environment

if sinatra_env != :production
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/#{sinatra_env.to_s}.db")
  DataMapper.auto_upgrade!
  if sinatra_env == :test
    DataMapper.auto_migrate!
    DataMapper.auto_upgrade!
  end
else
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/d94cj66kjs5ei')
end

DataMapper.finalize
unless DataMapper.repository(:default).adapter.storage_exists?('clients')
	DataMapper.auto_migrate!
else
	DataMapper.auto_upgrade!
end

