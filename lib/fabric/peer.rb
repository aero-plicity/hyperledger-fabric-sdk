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

                    # Handle the "grpc.ssl_target_name_override" value, and check for nil
                    if channel_args["grpc.ssl_target_name_override"].nil?
                      GRPC.logger.warn("grpc.ssl_target_name_override is nil; skipping this option.")
                      grpc_channel_options = {} # Skip the option if it's nil
                    else
                      grpc_channel_options = {
                        "grpc.ssl_target_name_override" => channel_args["grpc.ssl_target_name_override"]
                      }
                    end

                    # Pass the gRPC channel options as part of the channel initialization
                    channel = GRPC::Core::Channel.new(
                      host,                # Host (peer address)
                      grpc_channel_options, # gRPC channel options
                      channel_creds         # TLS credentials
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
