require 'peer/peer_services_pb'

module Fabric
  class Peer < ClientStub
    def client
      @client ||= begin
                    # Create channel credentials from the provided certificate
                    channel_creds = GRPC::Core::ChannelCredentials.new(creds)

                    # Ensure `options` has valid gRPC channel args and correct key-value pairs
                    stringified_options = options.transform_keys(&:to_s).transform_values do |v|
                      v.is_a?(Symbol) ? v.to_s : v
                    end

                    # Extract channel_args from options if they exist
                    channel_args = stringified_options.delete("channel_args") || {}

                    # Pass the channel args along with other options as keyword arguments
                    Protos::Endorser::Stub.new(
                      host,
                      channel_creds,
                      **channel_args,       # Pass the channel args as keyword arguments
                      **stringified_options # Pass remaining options as keyword arguments
                    )
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
