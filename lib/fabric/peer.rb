require 'peer/peer_services_pb'

module Fabric
  class Peer < ClientStub
    def client
      @client ||= begin
                    # Assume `host`, `creds`, and `options` are directly available in scope as you mentioned.
                    # Create channel credentials from the provided certificate
                    channel_creds = GRPC::Core::ChannelCredentials.new(creds)

                    # Create the gRPC channel using host, options (channel args), and credentials
                    channel = GRPC::Core::Channel.new(
                      host,
                      options.transform_keys(&:to_s),
                      channel_creds
                    )

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
