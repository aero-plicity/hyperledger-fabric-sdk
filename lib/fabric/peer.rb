require 'peer/peer_services_pb'

module Fabric
  class Peer < ClientStub
    def client
      @client ||= begin
                    # # Fetch the peer configuration dynamically
                    # peer_config = fetch_peer_config
                    #
                    # # Extract host, creds, and channel_args from the configuration
                    # host = peer_config[:host]
                    # creds = peer_config[:creds]  # The certificate contents
                    # channel_args = peer_config[:channel_args]  # Your custom gRPC options

                    # Create channel credentials from the provided certificate
                    channel_creds = GRPC::Core::ChannelCredentials.new(creds)

                    # Ensure channel arguments and credentials are both passed correctly
                    merged_options = options.merge({ channel_credentials: channel_creds })

                    # Create the gRPC channel with the host and merged options (channel args and credentials)
                    channel = GRPC::Core::Channel.new(host, merged_options)

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
