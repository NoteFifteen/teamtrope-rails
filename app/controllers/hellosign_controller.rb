require 'json'

class HellosignController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def record_event
    event = JSON.parse(params[:json])
    if event['signature_request']
      id = event['signature_request']['signature_request_id']
      document = HellosignDocument.where(hellosign_id: id).first_or_create
      document.update_attributes(status: event['event']['event_type'])
    end
    render json: 'Hello API Event Received',
           status: :ok
  end
end
