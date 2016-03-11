module OptClient
  module V1
    class Client

      @@ObjectFields = [:id, :email, :mobile, :first_name,
          :last_name, :permission_type,
          :channel, :company_name, :instrument]

      def attributes
        self.instance_variables.map do |var|
          key = var.to_s.gsub('@','').to_sym
          [key, instance_variable_get(var)] if @@ObjectFields.include?(key)
        end.to_h
      end

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
        @id ? update : create
      end

      def destroy
        @instrument.destroy(@id) if @id
        false
      end

    end


    class Instrument

      def initialize(version = 'v1', host = 'http://localhost:4567')
        @version = version.downcase
        @host = host
        @secret_key = Digest::MD5.hexdigest 'test_api'
      end

      def create(options = {})
        response = RestClient.post "#{@host}/api/#{@version}/clients",
                                   client: client_options(options), secret: @secret_key

        response = JSON.parse(response, :symbolize_names => true)
        return response.to_json unless response[:client]
        Client.new(response[:client], self)
      end


      def update(options = {})
        response = RestClient.patch "#{@host}/api/#{@version}/clients",
                                    client: client_options(options), secret: @secret_key

        response = JSON.parse(response, :symbolize_names => true)
        return response unless response[:client]
        Client.new(response[:client], self)
      end

      def destroy(id)
        response = RestClient.post "#{@host}/api/#{@version}/clients/destroy",
                                   client: {id: id}, secret: @secret_key

        response = JSON.parse(response, :symbolize_names => true)
        return response unless response[:status] == 'ok'
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