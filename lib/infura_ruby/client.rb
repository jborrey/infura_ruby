require 'faraday'
require 'json'

module InfuraRuby
  class Client
    class InfuraCallError < StandardError; end
    class InvalidEthereumAddressError < StandardError; end

    ETHEREUM_ADDRESS_REGEX = /^0x[0-9a-fA-F]{40}$/

    # Infura URLs for each network.
    NETWORK_URLS = {
      main:      'https://mainnet.infura.io',
      test:      'https://ropsten.infura.io',
      consensys: 'https://consensysnet.inufra.io'
    }.freeze

    JSON_RPC_METHODS = [
      'eth_getBalance'
    ].freeze

    BLOCK_PARAMETERS = [
      /^0x[0-9a-fA-F]{1,}$/, # an integer block number (hex string)
      /^earliest$/,          # for the earliest/genesis block
      /^latest$/,            # for the latest mined block
      /^pending$/            # for the pending state/transactions
    ].freeze

    def initialize(api_key:, network: :main)
      validate_api_key(api_key)
      validate_network(network)

      @api_key = api_key
      @network = network
    end

    # TODO: move calls out of client - worth doing when we have > 1.
    # Returns balance of address in wei as integer.
    def get_balance(address, tag: 'latest')
      validate_address(address)
      validate_block_tag(tag)

      resp = conn.post do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = json_rpc(method: 'eth_getBalance', params: [address, tag]).to_json
      end
      resp_body  = JSON.parse(resp.body)

      if resp_body['error']
        raise InfuraCallError.new(
          "Error (#{resp_body['error']['code']}): Infura API call "\
          "eth_getBalance gave message: '#{resp_body['error']['message']}'"
        )
      else
        wei_amount_hex_string = resp_body['result']
        wei_amount_hex_string.to_i(16)
      end
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

    def validate_block_tag(tag)
      if BLOCK_PARAMETERS.none? { |regex| regex =~ tag.to_s }
        raise NotImplementedError.new("Block parameter tag '#{tag}' does not exist.")
      end
    end

    def validate_address(address)
      if ETHEREUM_ADDRESS_REGEX !~ address
        raise InvalidEthereumAddressError.new("'#{address}' is not a valid ethereum address.")
      end
    end

    def validate_json_rpc_method(method)
      if !JSON_RPC_METHODS.include?(method)
        raise NotImplementedError.new("JSON RPC method '#{method}' does not exist.")
      end
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
