require 'peer/peer_services_pb'

module Fabric
  class Peer < ClientStub
    def client
      @client ||= begin
                    # Assume `host`, `creds`, and `options` are directly available in scope as you mentioned.

                    # Create channel credentials from the provided certificate
                    channel_creds = GRPC::Core::ChannelCredentials.new(creds)

                    # Transform the options hash from symbols to strings if needed
                    stringified_options = options.transform_keys(&:to_s)

                    # Pass channel args via the channel_args keyword argument, not as a second parameter
                    channel = GRPC::Core::Channel.new(
                      host, # Host
                      channel_args: stringified_options, # Channel options
                      creds: channel_creds # TLS credentials
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
