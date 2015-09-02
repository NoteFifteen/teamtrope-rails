require 'json'

class HellosignController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def record_event
    event = JSON.parse(params[:json])

    if event['signature_request']
      id = event['signature_request']['signature_request_id']
      document = HellosignDocument.where(hellosign_id: id).first_or_create
      document.update_attributes(status: event['event']['event_type'])

      is_complete = true
      event['signature_request']['signatures'].each do | signature |
        hellosign_signature = HellosignSignature.find_by_signature_id(signature['signature_id'])
        hellosign_signature.status_code = signature['status_code']

        hellosign_signature.last_viewed_at = DateTime.strptime signature['last_viewed_at'].to_s, '%s' unless signature['last_viewed_at'].nil?
        hellosign_signature.last_reminded_at = DateTime.strptime signature['last_reminded_at'].to_s, '%s' unless signature['last_reminded_at'].nil?
        hellosign_signature.signed_at = DateTime.strptime signature['signed_at'].to_s, '%s' unless signature['signed_at'].nil?

        hellosign_signature.save

        is_complete = false if signature['status_code'] != 'signed'

      end

      document.update_attributes(is_complete: true) if is_complete

    end

    render json: 'Hello API Event Received',
           status: :ok
  end
end
