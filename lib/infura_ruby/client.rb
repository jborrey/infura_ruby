require 'faraday'
require 'json'

module InfuraRuby
  class Client
    # Infura URLs for each network.
    NETWORK_URLS = {
      main:      'https://mainnet.infura.io',
      test:      'https://ropsten.infura.io',
      consensys: 'https://consensysnet.inufra.io'
    }.freeze

    JSON_RPC_METHODS = [
      'eth_getBalance'
    ].freeze

    def initialize(api_key:, network: :main)
      validate_api_key(api_key)
      validate_network(network)

      @api_key = api_key
      @network = network
    end

    # Returns balance of address in wei as integer.
    def get_balance(address)
      resp = conn.post do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = json_rpc(method: 'eth_getBalance', params: [address, 'latest']).to_json
      end

      resp_body  = JSON.parse(resp.body)
      wei_amount_hex_string = resp_body['result']
      wei_amount_hex_string.to_i(16)
    end

    private

    # TODO: this JSON RPC object should be a whole object / gem.
    def json_rpc(method:, params:)
      validate_json_rpc_method(method)
      
      {
        "jsonrpc" => "2.0",
        "method"  => method,
        "params"  => params,
        "id"      => 1
      }
    end

    def validate_json_rpc_method(method)
      raise NotImplementedError unless JSON_RPC_METHODS.include?(method)
    end

    def conn
      @conn ||= Faraday.new(
        url: "#{NETWORK_URLS[@network]}/#{@api_key}",
      )
    end

    def validate_api_key(api_key)
      raise InvalidApiKeyError unless /^[a-zA-Z0-9]{20}$/ =~ api_key
    end

    def validate_network(network)
      raise InvalidNetworkError if NETWORK_URLS[network].nil?
    end
  end
end
