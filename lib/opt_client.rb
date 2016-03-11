require "opt_client/version"
require 'json'
require 'rest-client'

# include supported versions
require 'opt_client/v1/v1'

module OptClient

  def self.init_api(options = {})
    options[:version] = options[:version] || 'v1'
    options[:host] = options[:host] || 'http://localhost:4567'
    include Object.const_get("OptClient::#{options[:version].capitalize}")
    OptClient::Instrument.new(options[:version], options[:host])
  end

end
