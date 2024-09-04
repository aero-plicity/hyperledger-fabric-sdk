require 'peer/peer_services_pb'

module Fabric
  class Peer < ClientStub
    def client
      @client ||= begin
                    # Ensure `options` has valid gRPC channel args and correct key-value pairs
                    stringified_options = options.transform_keys(&:to_s).transform_values do |v|
                      v.is_a?(Symbol) ? v.to_s : v
                    end

                    # Extract channel_args from options if they exist
                    args = stringified_options.delete("channel_args") || {}

                    # Handle the "grpc.ssl_target_name_override" and other channel args
                    grpc_channel_options = {
                      "grpc.ssl_target_name_override" => args["grpc.ssl_target_name_override"]
                    }.compact # Remove nil values from the hash, if any

                    # Combine the stringified options with the channel arguments
                    combined_options = stringified_options.merge(
                      channel_args: grpc_channel_options
                    )

                    # Return the gRPC stub client using the host, credentials, and options
                    Protos::Endorser::Stub.new(
                      host,                # Host (peer address)
                      creds,               # Credentials (TLS credentials)
                      **combined_options   # Pass options as keyword arguments
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
