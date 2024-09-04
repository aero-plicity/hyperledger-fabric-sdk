require 'peer/peer_services_pb'

module Fabric
  class Peer < ClientStub
    def client
      @client ||= begin
                    # Create channel credentials from the provided certificate
                    channel_creds = GRPC::Core::ChannelCredentials.new(creds)

                    # Transform the options hash from symbols to strings (gRPC expects string keys for channel args)
                    stringified_options = options.transform_keys(&:to_s)

                    # Create the gRPC channel using the host, channel arguments (options), and credentials
                    channel = GRPC::Core::Channel.new(
                      host,               # Host (peer address)
                      stringified_options, # Channel options (string keys)
                      channel_creds        # TLS credentials
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
