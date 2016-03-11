module OptClient
  module V1
    class Client
      include DataMapper::Resource

      property :id, Integer
      property :email, String, :required => true, :format => :email_address
      property :mobile, Integer, :required => true
      property :first_name, String, :required => true
      property :last_name, String, :required => true
      property :permission_type, String, :required => true, :set => %w|one-time permanent|
      property :channel, String, :required => true, :set => %w| sms email sms+email |

      property :company_name, String, :required => true, :unique => [:channel],
               message: "You can create Only one channel type for Company"


      attr_accessor	:id, :email, :mobile, :first_name,
                     :last_name, :permission_type,
                     :channel, :company_name, :instrument

      def initialize(options = {}, instrument = nil)
        @id = options[:id]
        @email = options[:email]
        @mobile = options[:mobile]
        @first_name = options[:first_name]
        @last_name = options[:last_name]
        @permission_type = options[:permission_type]
        @channel = options[:channel]
        @company_name = options[:company_name]
        @instrument = instrument
      end


      def update(options = {})
        raise({responce: 'set instrument instance or use Instrument update method',status: :error}.to_json) unless @instrument
        @instrument.update(self.attributes.merge!(options))
      end

      def create
        raise({responce: 'set instrument instance or use Instrument create method',status: :error}.to_json) unless @instrument
        @instrument.create(self.attributes)
      end

      def save
        return {responce: 'set instrument instance or use Instrument create method',status: :error} unless @instrument
        if @id
          update
        else
          create
        end
      end

      def destroy
        @instrument.destroy(@id)
      end

    end


    class Instrument

      def initialize(version = 'v1', host = 'http://localhost:4567')
        @version = version
        @host = host
        @secret_key = Digest::MD5.hexdigest 'test_api'
      end

      def create(options = {})
        response = RestClient.post "#{@host}/api/#{@version}/clients",
                                   client: client_options(options), secret: @secret_key

        response = JSON.parse(response, :symbolize_names => true)
        raise(response.to_json) unless response[:client]
        Client.new(response[:client], self)
      end


      def update(options = {})
        response = RestClient.patch "#{@host}/api/#{@version}/clients",
                                    client: client_options(options), secret: @secret_key

        response = JSON.parse(response, :symbolize_names => true)
        raise(response.to_json) unless response[:client]
        Client.new(response[:client], self)
      end

      def destroy(id)
        response = RestClient.post "#{@host}/api/#{@version}/clients/destroy",
                                   client: {id: id}, secret: @secret_key

        response = JSON.parse(response, :symbolize_names => true)
        raise(response.to_json) unless response[:status] == 'ok'
        true
      end

      protected

      def client_options(options)
        options.select{ |key, value| [:id, :email, :mobile, :first_name,
                                      :last_name, :permission_type,
                                      :channel, :company_name].include?(key)
        }
            .delete_if { |k, v| v.nil? }
      end

    end
  end
end