lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'infura_ruby/version'

Gem::Specification.new do |spec|
  spec.name          = "infura_ruby"
  spec.version       = InfuraRuby::VERSION
  spec.authors       = ["Julian Borrey"]
  spec.email         = ["julianborrey@gmail.com"]

  spec.summary       = "Library for the INFURA API."
  spec.description   = "Ruby client to the INFURA (infura.io) API. Allows HTTP "\
                       "access to ethereum and IPFS nodes."
  spec.homepage      = "https://github.com/jborrey/infura_ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(/^spec/) }
  spec.require_paths = ["lib"]

  spec.add_dependency "farady", "~> 0.11.0"
  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
