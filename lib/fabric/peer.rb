require 'peer/peer_services_pb'

module Fabric
  class Peer < ClientStub
    def client
      # Create a secure channel with credentials and options dynamically
      @client ||= begin
                    # Create channel credentials from the provided certificate
                    channel_creds = GRPC::Core::ChannelCredentials.new(creds)

                    # Create the gRPC channel with credentials and options
                    channel = GRPC::Core::Channel.new(host, options, channel_creds)

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
