require "opt_client/version"
require 'json'
require 'rest-client'
require 'data_mapper'
require 'opt_client'
# include supported versions
require 'opt_client/v1/v1'

module OptClient

  def self.init_api(version = 'v1', host = 'http://localhost:4567')
    include Object.const_get("OptClient::#{version.capitalize}")
    OptClient::Instrument.new(version, host)
  end

end
