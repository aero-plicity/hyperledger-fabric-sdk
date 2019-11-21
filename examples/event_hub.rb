require 'hyperledger-fabric-sdk'

fabric_ca_client = FabricCA.new(
  endpoint: "http://localhost:7054",
  username: "admin",
  password: "adminpw"
)

crypto_suite = Fabric.crypto_suite

user_identity = Fabric::Identity.new(
  crypto_suite,
  {
    username: "admin",
    affiliation: "org1.department1",
    mspid: 'Org1MSP'
  }
)

enrollment_response = fabric_ca_client.enroll(user_identity.generate_csr([%w(CN admin)]))

user_identity.certificate = enrollment_response[:result][:Cert]

event_hub = Fabric.event_hub identity: user_identity,
                             channel_id: 'mychannel',
                             event_hub_url: 'localhost:7051'

start_block = 0
stop_block = Fabric::EventHub::MAX_BLOCK_NUMBER

event_hub.observe(start_block, stop_block) do |block|
  tx_validation_codes = block[:metadata][:metadata][2]

  block[:data][:data].each_with_index do |data, index|
    tx_validation_code = Protos::TxValidationCode.lookup(tx_validation_codes[index]).to_s

    transaction = {
      id: data[:payload][:header][:channel_header][:tx_id],
      timestamp: data[:payload][:header][:channel_header][:timestamp],
      validation_code: tx_validation_code
    }

    p transaction
  end
end
