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
                    channel_args = stringified_options.delete("channel_args") || {}

                    # Apply grpc.ssl_target_name_override if available
                    grpc_channel_options = channel_args.transform_keys(&:to_s)

                    # Check if grpc.ssl_target_name_override is provided and log a warning if not
                    if grpc_channel_options["grpc.ssl_target_name_override"].nil?
                      logger.warn("grpc.ssl_target_name_override is missing! This may cause SSL connection issues.")
                    end

                    # Define additional options for the gRPC stub initializer
                    opts = {
                      channel_args: grpc_channel_options
                    }

                    # Return the gRPC stub client using the host, credentials, and options
                    Protos::Endorser::Stub.new(
                      host,                # Host (peer address)
                      creds,               # Credentials (TLS credentials)
                      **opts               # Pass recognized options as keyword arguments
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
