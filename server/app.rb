require 'sinatra'
                      require 'data_mapper'
                      require 'json'
                      require 'sinatra/contrib'
                      require 'dm-migrations'
                      require 'dm-sqlite-adapter' 
set :environment, ENV['RACK_ENV'].downcase.to_sym

class Client
  include DataMapper::Resource
  property :id, Serial
  property :email, String, :required => true, :format => :email_address
  property :mobile, Integer, :required => true
  property :first_name, String, :required => true
  property :last_name, String, :required => true
  property :permission_type, String, :required => true, :set => %w|one-time permanent|
  property :channel, String, :required => true, :set => %w| sms email sms+email |

  property :company_name, String, :required => true, :unique => [:channel],
           message: "You can create Only one channel type for Company"
end



get '/' do
  @clients = Client.all(:order => [ :company_name.asc ])
  response = ''
  @clients.each do |client|
    response += "id: #{client.id} | email: #{client.email} | company_name: #{client.company_name} | mobile: #{client.mobile} <br>"
  end
  response
end

get '/connected' do
  {status: :ok}.to_json
end

namespace '/api' do
  namespace '/v1' do

    before do
      @secret_key = Digest::MD5.hexdigest 'test_api'
      halt 401, {'Content-Type' => 'text/plain'}, 'Message!' unless params[:secret] == @secret_key
    end

    post '/clients' do
      begin
        client = Client.new(params[:client])
        if client.save
          {client: client.attributes, status: :ok}.to_json
        else
          {error: client.errors.full_messages.join(', '), status: :error}.to_json
        end
      rescue => error
        raise({error: error, status: :error}.to_json)
      end
    end


    patch '/clients' do
      begin
        client = Client.get(params[:client][:id])
        if client && client.update(params[:client])
          # puts 'client && client.update(params[:client])'
          {client: client.attributes, status: :ok}.to_json
        else
          # puts "{error: client.errors.full_messages.join(', '), status: :error}.to_json"
          {error: "Not updated. ID: #{params[:client][:id]}", status: :error}.to_json
        end
      rescue => error
        raise({error: error, status: :error}.to_json)
      end
    end

    post '/clients/destroy' do
      begin
        client = Client.get(params[:client][:id])
        if client && client.destroy
          {status: :ok}.to_json
        else
          {error: "Record Not found with id #{params[:client][:id]}", status: :error}.to_json
        end
      rescue => error
        raise({error: error, status: :error}.to_json)
      end
    end
  end
end
