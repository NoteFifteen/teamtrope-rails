class CancelRequestJob
  include Resque::Plugins::Status

  @queue = :cancel_signing_request
  def perform
    hellosign_document_id = options["hellosign_document_id"]
    raise "Missing hellosign_document_id" if options["hellosign_document_id"].nil?

    @hellosign_document = HellosignDocument.find(hellosign_document_id)

    #cancel the request
    begin
      HelloSign.cancel_signature_request signature_request_id: @hellosign_document.hellosign_id
        @hellosign_document.update_attributes(pending_cancellation: true)
    rescue HelloSign::Error::Gone => e
      @hellosign_document.update_attributes(cancelled: true)
      return true
    end

    #check to see if it was actually cancelled
    begin
      HelloSign.cancel_signature_request signature_request_id: @hellosign_document.hellosign_id
    rescue Hellosign::Error::Gone => e
      @hellosign_document.update_attributes(pending_cancellation: false, cancelled: true)
      return true
    end

  end

end
