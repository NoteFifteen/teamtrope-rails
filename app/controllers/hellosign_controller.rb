require 'json'

class HellosignController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def record_event
    event = JSON.parse(params[:json])

    if event['signature_request']
      id = event['signature_request']['signature_request_id']
      document = HellosignDocument.where(hellosign_id: id).first_or_create
      document.update_attributes(status: event['event']['event_type'])

      # if a signing request is created outside of teamtrope we need to map the
      # the new document to an existing document type if we find one.
      if document.hellosign_document_type_id.nil?
        document_type = HellosignDocumentType.find_by_subject(event['signature_request']['subject'])
        document.update_attributes(hellosign_document_type: document_type) unless document_type.nil?
      end

      is_complete = true
      event['signature_request']['signatures'].each do | signature |
        hellosign_signature = HellosignSignature.find_by_signature_id(signature['signature_id'])
        # skip if there is no signature in the db that matches 'signature_id'
        # odds are the documet was created on a dev box.
        # TODO: ensure dev versions of the document don't mix with live.
        next if hellosign_signature.nil?
        hellosign_signature.status_code = signature['status_code']

        hellosign_signature.last_viewed_at = DateTime.strptime signature['last_viewed_at'].to_s, '%s' unless signature['last_viewed_at'].nil?
        hellosign_signature.last_reminded_at = DateTime.strptime signature['last_reminded_at'].to_s, '%s' unless signature['last_reminded_at'].nil?
        hellosign_signature.signed_at = DateTime.strptime signature['signed_at'].to_s, '%s' unless signature['signed_at'].nil?

        hellosign_signature.save

        is_complete = false if signature['status_code'] != 'signed'
      end

      project = document.team_membership.project
      case event['event']['event_type']
      when 'signature_request_sent'
        activity = :hs_signature_request_sent
        text = " was sent a #{document.name}"
      when 'signature_request_viewed'
        activity = :hs_signature_request_viewed
        text = " viewed #{document.name}"
      when 'signature_request_signed'
        activity = :hs_signature_request_signed
        text = " signed #{document.name}"
      else
      end

      signature = document.signatures.find_by_signature_id(event['event']['event_metadata']['related_signature_id'])
      owner = signature.member unless signature.nil?

      project.create_activity activity,
        owner: document.signatures.order(:order).first.member,
        parameters: { text: text } if activity && ! owner.nil?

      document.update_attributes(is_complete: true) if is_complete
    end

    render json: 'Hello API Event Received',
           status: :ok
  end
end
