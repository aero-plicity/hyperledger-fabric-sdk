# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: peer/chaincode.proto

require 'google/protobuf'

require 'google/protobuf/timestamp_pb'
Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "protos.ChaincodeID" do
    optional :path, :string, 1
    optional :name, :string, 2
    optional :version, :string, 3
  end
  add_message "protos.ChaincodeInput" do
    repeated :args, :bytes, 1
  end
  add_message "protos.ChaincodeSpec" do
    optional :type, :enum, 1, "protos.ChaincodeSpec.Type"
    optional :chaincode_id, :message, 2, "protos.ChaincodeID"
    optional :input, :message, 3, "protos.ChaincodeInput"
    optional :timeout, :int32, 4
  end
  add_enum "protos.ChaincodeSpec.Type" do
    value :UNDEFINED, 0
    value :GOLANG, 1
    value :NODE, 2
    value :CAR, 3
    value :JAVA, 4
  end
  add_message "protos.ChaincodeDeploymentSpec" do
    optional :chaincode_spec, :message, 1, "protos.ChaincodeSpec"
    optional :effective_date, :message, 2, "google.protobuf.Timestamp"
    optional :code_package, :bytes, 3
    optional :exec_env, :enum, 4, "protos.ChaincodeDeploymentSpec.ExecutionEnvironment"
  end
  add_enum "protos.ChaincodeDeploymentSpec.ExecutionEnvironment" do
    value :DOCKER, 0
    value :SYSTEM, 1
  end
  add_message "protos.ChaincodeInvocationSpec" do
    optional :chaincode_spec, :message, 1, "protos.ChaincodeSpec"
    optional :id_generation_alg, :string, 2
  end
  add_enum "protos.ConfidentialityLevel" do
    value :PUBLIC, 0
    value :CONFIDENTIAL, 1
  end
end

module Protos
  ChaincodeID = Google::Protobuf::DescriptorPool.generated_pool.lookup("protos.ChaincodeID").msgclass
  ChaincodeInput = Google::Protobuf::DescriptorPool.generated_pool.lookup("protos.ChaincodeInput").msgclass
  ChaincodeSpec = Google::Protobuf::DescriptorPool.generated_pool.lookup("protos.ChaincodeSpec").msgclass
  ChaincodeSpec::Type = Google::Protobuf::DescriptorPool.generated_pool.lookup("protos.ChaincodeSpec.Type").enummodule
  ChaincodeDeploymentSpec = Google::Protobuf::DescriptorPool.generated_pool.lookup("protos.ChaincodeDeploymentSpec").msgclass
  ChaincodeDeploymentSpec::ExecutionEnvironment = Google::Protobuf::DescriptorPool.generated_pool.lookup("protos.ChaincodeDeploymentSpec.ExecutionEnvironment").enummodule
  ChaincodeInvocationSpec = Google::Protobuf::DescriptorPool.generated_pool.lookup("protos.ChaincodeInvocationSpec").msgclass
  ConfidentialityLevel = Google::Protobuf::DescriptorPool.generated_pool.lookup("protos.ConfidentialityLevel").enummodule
end
