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

                    # Create the gRPC channel using the host, channel arguments (options), and credentials
                    # Updated: Pass channel options as keyword arguments instead of a hash
                    Protos::Endorser::Stub.new(
                      host,
                      channel_creds,
                      **stringified_options   # Pass options as keyword arguments
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
