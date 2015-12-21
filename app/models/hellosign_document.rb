class HellosignDocument < ActiveRecord::Base
  belongs_to :hellosign_document_type
  belongs_to :team_membership

  delegate :name, :template_id, :subject, :message, :ccs, :signers, to: :hellosign_document_type, allow_nil: true

  has_many :hellosign_signatures, dependent: :destroy
  alias :signatures :hellosign_signatures

  # factory method used to create a 'Creative Team Agreement' and send the signing request.
  def HellosignDocument.send_creative_team_agreement(team_membership)

    creative_team_agreement = HellosignDocumentType.find_by_name("Creative Team Agreement")


    raise "We can't create 'Creative Team Agreements' without a matching HellosignDocumentType" if creative_team_agreement.nil?

    raise "The project layout doesn't exist for project id: #{team_membership.project.id}" if team_membership.project.layout.nil?

    raise "No legal name provided for the author, project id: #{team_membership.project.id}" if team_membership.project.layout.legal_name.nil?

    hellosign_document = creative_team_agreement.hellosign_documents.new(
      team_membership_id: team_membership.id
    )

    signers = [
      {
        email_address: team_membership.member.email,
        name: team_membership.member.name,
        role: 'TeamMember'
      }
    ]

    custom_fields = {
      book_title: team_membership.project.book_title,
      team_role: team_membership.role.name,
      legal_name: team_membership.project.layout.legal_name,
      pen_name: team_membership.project.layout.use_pen_name_on_title ? team_membership.project.layout.pen_name  : "N/A",
    }.merge(hellosign_document.prepare_parties_and_payments(TeamMembership.where(project_id: team_membership.project_id)))

    hellosign_document.send_agreement(custom_fields, signers)

    hellosign_document
  end

  def prepare_parties_and_payments(team_memberships)
    parties = ""
    payments = ""
    team_memberships.each do | team_membership |
      parties << "#{team_membership.role.name}: #{team_membership.member.name}\n"
      # sprintf %g will only print a decimal if not whole number
      payments << "#{team_membership.role.name}: #{sprintf("%g", team_membership.percentage)}%\n"
    end
    {parties: parties, payments: payments}
  end

  def send_agreement(custom_fields, signers)

    #send the signature request to hellosign using their api
    begin
      response = HelloSign.send_signature_request_with_template(
                    build_hellosign_payload(custom_fields, signers)
      )
    rescue StandardError => e
      #todo: determine if we need to do anything if we trap the error.
      # for now we just raise the error
      raise e
    end

    #update the hellosign_id with the guid returned in the response.
    self.update_attributes(
      hellosign_id: response.data['signature_request_id'],
      signing_url: response.data['signing_url'],
      files_url: response.data['files_url'],
      details_url: response.data['details_url'],
      is_complete: response.data['is_complete'],
      has_error: response.data['has_error']
    )

    #creating the hellosign signatures that represent the people that must sign this document
    response.data['signatures'].each do | signature |
      member_id = nil
      if member = User.find_by_email(signature['signer_email_address'])
        member_id = member.id
      end
      self.hellosign_signatures.create!(
        signature_id: signature['signature_id'],
        signer_email_address: signature['signer_email_address'],
        signer_name: signature['signer_name'],
        order: signature['order'],
        status_code: signature['status_code'],
        signed_at: signature['signed_at'],
        last_viewed_at: signature['last_viewed_at'],
        last_reminded_at: signature['last_reminded_at'],
        error: signature['error'],
        member_id: member_id
      )
    end
  end

  def pending_cancellation?
    pending_cancellation
  end

  def cancelled?
    cancelled
  end

  def has_error?
    has_error
  end

  def complete?
    is_complete
  end

  private
  def build_hellosign_payload(custom_fields, signers, mode = Figaro.env.hello_sign_status)
    {
      test_mode: (mode == 'live')? false : true,
      template_id: template_id,
      subject: subject,
      message: message,
      signers: prepare_signers(signers, mode),
      ccs: prepare_ccs,
      custom_fields: custom_fields.deep_symbolize_keys
    }
  end

  # Prepare signers and sanitize if necessary
  def prepare_signers(signers, mode = Figaro.env.hello_sign_status)
    signers = (signers + self.signers).map(&:deep_symbolize_keys)
    sanitize(signers, mode)
  end

  # prepare and sanitize* the ccs (* if necessary)
  def prepare_ccs(mode = Figaro.env.hello_sign_status)
    sanitize(self.ccs.map(&:deep_symbolize_keys), mode)
  end


  def sanitize(santize_these, mode = Figaro.envv.hello_sign_status)
    if mode == 'live'
      santize_these
    else
      santize_these.each do | signer |
        signer[:email_address] = HellosignDocument.sanitize_address(signer[:role])
      end
      santize_these
    end
  end

  #TODO: consider moving this to constants if we plan to use this role map elsewhere
  HELLOSIGN_ROLES = {
    "TeamMember"     => Figaro.env.hellosign_override_team_member,
    "Booktrope-CEO"  => Figaro.env.hellosign_override_ceo,
    'Intake Manager' => Figaro.env.hellosign_override_intake,
    'HR/Accounting'  => Figaro.env.hellosign_override_hr,
    'DEFAULT'        => Figaro.env.hellosign_document_default
  }

  # santize the email address to send to hellosign based upon what's defined in
  # application.yml
  def HellosignDocument.sanitize_address(hellosign_role)
    #default to justin.jeffress@booktrope if the overrides aren't set in application.yml
    HELLOSIGN_ROLES[hellosign_role] || HELLOSIGN_ROLES['DEFAULT'] || "justin.jeffress@booktrope.com"
  end
end
