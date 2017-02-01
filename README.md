# InfuraRuby

Ruby gem to wrap the [INFURA](https://github.com/ethereum/wiki/wiki/JSON-RPC) API which gives HTTP API access to ethereum and IPFS nodes. The API uses the same format as the [JSON RPC spec](https://github.com/ethereum/wiki/wiki/JSON-RPC) for normal ethereum nodes.

For now, I only need the `getBalance` call and so that is all I have built. Feel free to add the rest of the functionality or I may get to it over time...

## Usage

__Installation__
```bash
gem install infura_ruby
```

```ruby
require 'infura_ruby'

# create a client object
infura = InfuraRuby.client(api_key: key)

# get the balance (in wei) of an address
infura.get_balance('0x81F631b8615EaB75d38DaC4d4bce4A5b63e10310') #=> 591686024850016

# This can be qualified with 4 different tags to get the balance at the tag's time.
# 'latest'   - latest balance (default) with at least 1 confirmation
# 'pending'  - balance including pending transactions
# 'earliest' - balance at the time of the genesis block or earliest known block
# '0x123'    - balance at the time of chain height `0x123` (hex string)

# balance including unconfirmed transactions
infura.get_balance('0x81F631b8615EaB75d38DaC4d4bce4A5b63e10310', tag: 'pending')
```
