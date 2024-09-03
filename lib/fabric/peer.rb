require 'peer/peer_services_pb'

module Fabric
  class Peer < ClientStub
    def client
      @client ||= Protos::Endorser::Stub.new(host, creds)
    end

    def send_process_proposal(proposal)
      logging :send_process_proposal_request, proposal.to_h

      # Extract metadata from options or provide default
      metadata = options[:metadata] || {}

      # If there are additional options like deadlines, add them to metadata
      if options[:deadline]
        deadline = (Time.now.to_f + options[:deadline]).to_s
        metadata['deadline'] = deadline
      end

      response = client.process_proposal(proposal, metadata: metadata)

      logging :send_process_proposal_response, response.to_h

      response
    end
  end
end
