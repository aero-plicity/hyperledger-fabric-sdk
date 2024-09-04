require 'peer/peer_services_pb'

module Fabric
  class Peer < ClientStub
    def client
      @client ||= begin
                    # Fetch the peer configuration dynamically
                    peer_config = Fabric.config.peers.first

                    # Extract host, creds, and channel_args from the configuration
                    host = peer_config[:host]
                    creds = peer_config[:creds]  # The certificate contents
                    channel_args = peer_config[:channel_args]  # Your custom gRPC options

                    # Create channel credentials from the provided certificate
                    channel_creds = GRPC::Core::ChannelCredentials.new(creds)

                    # Create the gRPC channel with two arguments: host and channel_args
                    # The third argument for credentials must be set in the options
                    channel = GRPC::Core::Channel.new(host, channel_args, channel_creds)

                    # Return the gRPC stub client using the configured channel
                    Protos::Endorser::Stub.new(channel)
                  end
    end

    def send_process_proposal(proposal)
      logging :send_process_proposal_request, proposal.to_h

      response = client.process_proposal proposal

      logging :send_process_proposal_response, response.to_h

      response
    end
  end
end
