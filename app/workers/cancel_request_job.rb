class CancelRequestJob
  include Resque::Plugins::Status

  @queue = :cancel_signing_request

  def perform
    total_steps = 5
    steps_completed = 0
    hellosign_document_id = options["hellosign_document_id"]
    raise "Missing hellosign_document_id" if options["hellosign_document_id"].nil?

    at(steps_completed+=1, total_steps, "#{steps_completed} of #{total_steps} fetching hellosign document id: #{options["hellosign_document_id"]}")


    @hellosign_document = HellosignDocument.find(hellosign_document_id)

    at(steps_completed=+1, total_steps, "#{steps_completed} of #{total_steps} fetched hellosign document id: #{options["hellosign_document_id"]}")

    #cancel the request
    begin
      at(steps_completed+=1, total_steps, "#{steps_completed} of #{total_steps} sending cancellation request to hellosign")
      HelloSign.cancel_signature_request signature_request_id: @hellosign_document.hellosign_id
        @hellosign_document.update_attributes(pending_cancellation: true)
    rescue HelloSign::Error::Gone => e
      at(steps_completed,total_steps, "The document has already been cancelled.")
      @hellosign_document.update_attributes(cancelled: true)
      return true
    end

    #check to see if it was actually cancelled
    begin
      at(steps_completed+=1, total_steps, "#{steps_completed} of #{total_steps} confirming cancellation with hellosign")
      HelloSign.cancel_signature_request signature_request_id: @hellosign_document.hellosign_id
    rescue HelloSign::Error::Gone => e
      @hellosign_document.update_attributes(pending_cancellation: false, cancelled: true)
      at(steps_completed+=1, total_steps, "#{steps_completed} of #{total_steps} Task Complete: cancellation confirmed.")
      return true
    end
    set_status(unexpected: 'Unexpected result! If everything worked correctly we shouldn\'t make it this far.')
  end

end
