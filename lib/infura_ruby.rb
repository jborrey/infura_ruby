require_relative 'infura_ruby/version'
require_relative 'infura_ruby/client'

module InfuraRuby
  class InvalidApiKeyError < StandardError; end
  class InvalidNetworkError < StandardError; end

  class << self
    # Generate a new client for the Infura api.
    def client(api_key:, network: :main)
      Client.new(api_key: api_key, network: network)
    end
  end
end
