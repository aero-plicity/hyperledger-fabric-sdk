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

                    # Handle both string and symbol keys for grpc.ssl_target_name_override
                    ssl_target_name_override = args["grpc.ssl_target_name_override"] || args[:'grpc.ssl_target_name_override']

                    # Raise an error if the value is nil, or log a warning if it isn't set correctly
                    if ssl_target_name_override.nil?
                      logger.warn("grpc.ssl_target_name_override is missing or invalid! This may cause SSL connection issues.")
                    end

                    # Construct the channel_args with the ssl_target_name_override
                    channel_args = {
                      "grpc.ssl_target_name_override" => ssl_target_name_override
                    }

                    # Return the gRPC stub client using the host and credentials with options as kw args
                    Protos::Endorser::Stub.new(
                      host,                # Host (peer address)
                      creds,               # Credentials (TLS credentials)
                      channel_args: channel_args # Pass channel_args as a keyword argument
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
