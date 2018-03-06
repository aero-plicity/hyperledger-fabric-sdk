# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: peer/chaincode_shim.proto

require 'google/protobuf'

require 'peer/chaincode_event_pb'
require 'peer/proposal_pb'
require 'google/protobuf/timestamp_pb'
Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "protos.ChaincodeMessage" do
    optional :type, :enum, 1, "protos.ChaincodeMessage.Type"
    optional :timestamp, :message, 2, "google.protobuf.Timestamp"
    optional :payload, :bytes, 3
    optional :txid, :string, 4
    optional :proposal, :message, 5, "protos.SignedProposal"
    optional :chaincode_event, :message, 6, "protos.ChaincodeEvent"
  end
  add_enum "protos.ChaincodeMessage.Type" do
    value :UNDEFINED, 0
    value :REGISTER, 1
    value :REGISTERED, 2
    value :INIT, 3
    value :READY, 4
    value :TRANSACTION, 5
    value :COMPLETED, 6
    value :ERROR, 7
    value :GET_STATE, 8
    value :PUT_STATE, 9
    value :DEL_STATE, 10
    value :INVOKE_CHAINCODE, 11
    value :RESPONSE, 13
    value :GET_STATE_BY_RANGE, 14
    value :GET_QUERY_RESULT, 15
    value :QUERY_STATE_NEXT, 16
    value :QUERY_STATE_CLOSE, 17
    value :KEEPALIVE, 18
    value :GET_HISTORY_FOR_KEY, 19
  end
  add_message "protos.PutStateInfo" do
    optional :key, :string, 1
    optional :value, :bytes, 2
  end
  add_message "protos.GetStateByRange" do
    optional :startKey, :string, 1
    optional :endKey, :string, 2
  end
  add_message "protos.GetQueryResult" do
    optional :query_by_chaincode, :string, 1
  end
  add_message "protos.GetHistoryForKey" do
    optional :key, :string, 1
  end
  add_message "protos.QueryStateNext" do
    optional :id, :string, 1
  end
  add_message "protos.QueryStateClose" do
    optional :id, :string, 1
  end
  add_message "protos.QueryResultBytes" do
    optional :resultBytes, :bytes, 1
  end
  add_message "protos.QueryResponse" do
    repeated :results, :message, 1, "protos.QueryResultBytes"
    optional :has_more, :bool, 2
    optional :id, :string, 3
  end
end

module Protos
  ChaincodeMessage = Google::Protobuf::DescriptorPool.generated_pool.lookup("protos.ChaincodeMessage").msgclass
  ChaincodeMessage::Type = Google::Protobuf::DescriptorPool.generated_pool.lookup("protos.ChaincodeMessage.Type").enummodule
  PutStateInfo = Google::Protobuf::DescriptorPool.generated_pool.lookup("protos.PutStateInfo").msgclass
  GetStateByRange = Google::Protobuf::DescriptorPool.generated_pool.lookup("protos.GetStateByRange").msgclass
  GetQueryResult = Google::Protobuf::DescriptorPool.generated_pool.lookup("protos.GetQueryResult").msgclass
  GetHistoryForKey = Google::Protobuf::DescriptorPool.generated_pool.lookup("protos.GetHistoryForKey").msgclass
  QueryStateNext = Google::Protobuf::DescriptorPool.generated_pool.lookup("protos.QueryStateNext").msgclass
  QueryStateClose = Google::Protobuf::DescriptorPool.generated_pool.lookup("protos.QueryStateClose").msgclass
  QueryResultBytes = Google::Protobuf::DescriptorPool.generated_pool.lookup("protos.QueryResultBytes").msgclass
  QueryResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("protos.QueryResponse").msgclass
end
