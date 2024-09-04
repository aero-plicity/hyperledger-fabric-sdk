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

                    # Extract grpc.ssl_target_name_override and ensure it's a valid string
                    ssl_target_name_override = args["grpc.ssl_target_name_override"] || args[:'grpc.ssl_target_name_override']

                    # Ensure grpc.ssl_target_name_override is present and is a valid string
                    if ssl_target_name_override.nil? || !ssl_target_name_override.is_a?(String)
                      raise "grpc.ssl_target_name_override is required and must be a string, but got #{ssl_target_name_override.class}."
                    end

                    # Prepare the channel_args with grpc.ssl_target_name_override
                    channel_args = {
                      "grpc.ssl_target_name_override" => ssl_target_name_override
                    }

                    # Return the gRPC stub client using the host, credentials, and channel_args
                    Protos::Endorser::Stub.new(
                      host,               # Host (peer address)
                      creds,              # Credentials (TLS credentials)
                      channel_args: channel_args  # Pass channel_args for SSL target override
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
