class HellosignDocument < ActiveRecord::Base
  belongs_to :hellosign_document_type

  delegate :name, :template_id, :subject, :message, :ccs, :signers, to: :hellosign_document_type, allow_nil: true

  has_many :hellosign_signatures
  has_many :team_memberships, through: :hellosign_signatures

  alias :signatures :hellosign_signatures

  def HellosignDocument.send_creative_team_agreement(team_membership)

    creative_team_agreement = HellosignDocumentType.find_by_name("Creative Team Agreement")

    return if creative_team_agreement.nil?

    hellosign_document = creative_team_agreement.hellosign_documents.create!

    signers = [
      {
        email_address: team_membership.member.email,
        name: team_membership.member.name,
        role: 'Client'
      }
    ]

    custom_fields = {
      role: team_membership.role.name,
      role_description: team_membership.role.contract_description,
      percentage: team_membership.percentage
    }

    hellosign_document.send_agreement(custom_fields, signers)


    # hellosign_hash = create_team_agreement_hash(team_membership)
    # response = HelloSign.send_signature_request_with_template(hellosign_hash)
    #
    # doc = HellosignDocument.create!( name: 'Creative Team Agreement',
    #       hellosign_id: response.data['signature_request_id'] )
    #
    # doc.hellosign_signatures.create!( team_membership_id: team_membership.id )
  end

  def send_agreement(custom_fields, signers)
    response = HelloSign.send_signature_request_with_template(build_hellosign_payload(custom_fields, signers))

    self.update_attributes(hellosign_id: response.data['signature_request_id'])

  end

  def build_hellosign_payload(custom_fields, signers, mode = Figaro.env.hello_sign_status)
    {
      test_mode: (mode == 'live')? false : true,
      template_id: template_id,
      subject: subject,
      message: message,
      signers: (signers + self.signers).map(&:deep_symbolize_keys),
      ccs: self.ccs.map(&:deep_symbolize_keys),
      custom_fields: custom_fields.deep_symbolize_keys
    }
  end

  private
  def HellosignDocument.create_team_agreement_hash(team_membership, mode = Figaro.env.hello_sign_status)
    {
      # defaults to test_mode unless the mode is 'live'.
      # which is by default set to an environment variable.
      test_mode: (mode == 'live')? false : true,
      template_id: '3f53b709eaf29f4c19cd498fabdcec906679f671',
      subject: 'Teamtrope Creative Team Agreement',
      message: 'Please sign this document using HelloSign. Thank you!',
      signers:
      [
        {
          email_address: sanitize_address(team_membership.member.email, 'to'),
          name: team_membership.member.name,
          role: team_membership.role.name
        },
        {
          email_address: sanitize_address('justin.jeffress+ken@booktrope.com', 'to'),
          name: 'Ken Shear',
          role: 'Booktrope-CEO'
        }
      ],
      ccs:
      [
        { email_address: sanitize_address('justin.jeffress+intake@booktrope.com', 'cc'), role: 'Intake Manager'},
        { email_address: sanitize_address('justin.jeffress+hr@booktrope.com', 'cc'), role: 'HR/Accounting'}
      ],
      custom_fields:
      {
        role: team_membership.role.name,
        role_description: team_membership.role.contract_description,
        percentage: team_membership.percentage
      }
    }
  end

  # Make use of the Sanitizer which will use the config to get the correct recipients
  # and use them, but only if active.
  def HellosignDocument.sanitize_address(original_address, type)
    # Fake a message & pass it into the sanitizer
    mail       = Mail.new
    mail[:to]  = original_address
    mail[:cc]  = original_address
    mail[:bcc] = original_address
    sanitizer  = SanitizeEmail::OverriddenAddresses.new(mail)

    # Grab the sanitized address.  This method does not return the friendly name containing
    # the original address which HelloSign chokes on.
    sanitizer.send("sanitized_#{type}")
  end
end
