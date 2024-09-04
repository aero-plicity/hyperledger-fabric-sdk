Gem::Specification.new do |s|
  s.name          = 'hyperledger-fabric-sdk'
  s.version       = '0.3.0'
  s.date          = Time.now.strftime('%Y-%m-%d')
  s.summary       = "This SDK enables Ruby developers to interact with hyperledger-fabric"
  s.description   = "Ruby SDK for interacting with Hyperledger Fabric blockchain network."
  s.authors       = ["Alexandr Kirshin(kirshin)", "Bryan Padron(djlazz3)"]
  s.email         = 'support@aeroplicity.com'
  s.license       = 'MIT'
  s.required_ruby_version = '~>3.0'

  s.add_dependency 'faraday_middleware', '~>1.2'
  s.add_dependency 'faraday', '~>1.10'
  s.add_dependency 'grpc', '~>1.65'
  s.add_dependency 'google-protobuf', '~>3.25'
  s.add_dependency 'keccak', '~>1.3'
  s.add_dependency 'hashie', '~>5.0'
  s.add_dependency 'openssl', '~>2.2'

  s.add_development_dependency "bundler", "~> 2.0"
  s.add_development_dependency "rake", "~> 13.0"

  s.files         = ["lib/hyperledger-fabric-sdk.rb"]
  s.files         += Dir['lib/*.rb']
  s.files         += Dir['lib/**/*.rb']
  s.files         << "Gemfile"
  s.files         << "Gemfile.lock"
  s.files         << "LICENSE.txt"
  s.files         << "Rakefile"

  s.require_paths = [
    "lib",
    "lib/fabric",
    "lib/fabric/protos/commmon",
    "lib/fabric/protos/discovery",
    "lib/fabric/protos/gossip",
    "lib/fabric/protos/idemix",
    "lib/fabric/protos/ledger",
    "lib/fabric/protos/ledger/queryresult",
    "lib/fabric/protos/ledger/rwset",
    "lib/fabric/protos/ledger/rwset/kvrwset",
    "lib/fabric/protos/msp",
    "lib/fabric/protos/orderer",
    "lib/fabric/protos/orderer/etcdraft",
    "lib/fabric/protos/peer",
    "lib/fabric/protos/token",
    "lib/fabric/protos/transientstore",
    "lib/fabric/protos/definitions",
    "lib/fabric/protos/definitions/commmon",
    "lib/fabric/protos/definitions/discovery",
    "lib/fabric/protos/definitions/gossip",
    "lib/fabric/protos/definitions/idemix",
    "lib/fabric/protos/definitions/ledger",
    "lib/fabric/protos/definitions/ledger/queryresult",
    "lib/fabric/protos/definitions/ledger/rwset",
    "lib/fabric/protos/definitions/ledger/rwset/kvrwset",
    "lib/fabric/protos/definitions/msp",
    "lib/fabric/protos/definitions/orderer",
    "lib/fabric/protos/definitions/orderer/etcdraft",
    "lib/fabric/protos/definitions/peer",
    "lib/fabric/protos/definitions/token",
    "lib/fabric/protos/definitions/transientstore",
    "lib/fabric_ca",
    "lib/fabric_ca/faraday_middleware"
  ]

  s.homepage = 'https://github.com/kirshin/hyperledger-fabric-sdk'
end
