class CreateNewAndRetireCreativeTeamAgreementTemplate < ActiveRecord::Migration

  OLD_TEMPLATE_ID = "89b8470207a85ea8ea580fd8f0ac89fc0ca302fc"
  NEW_TEMPLATE_ID = "1f8b9f2f043c8dc39aa20998eb3df28f021f95d8"

  def up

    add_column :hellosign_document_types, :version, :string, before: :created_at

    old_document_type = HellosignDocumentType.find_by_template_id(OLD_TEMPLATE_ID)

    unless old_document_type.nil?
      old_document_type.update_attributes(name: "Creative Team Agreement - UP - TTR-242",
        version: 1.0)
    end

    new_document_type = HellosignDocumentType.where(template_id: NEW_TEMPLATE_ID).first_or_create(
      name: "Creative Team Agreement",
      subject: old_document_type.subject,
      message: old_document_type.message,
      template_id: NEW_TEMPLATE_ID,
      signers: [],
      ccs: [{"email_address"=>"payroll@booktrope.com", "role"=>"Payroll"}],
      version: "2.0"
    )

    if new_document_type.name != 'Creative Team Agreement'
      new_document_type.update_attributes(name: 'Creative Team Agreement')
    end

  end

  def down

    new_document_type = HellosignDocumentType.find_by_template_id(NEW_TEMPLATE_ID)
    unless new_document_type.nil?
      new_document_type.update_attributes(name: "Creative Team Agreement - DOWN - TTR-242")
    end

    old_document_type = HellosignDocumentType.find_by_template_id(OLD_TEMPLATE_ID)
    unless old_document_type.nil?
      old_document_type.update_attributes(name: "Creative Team Agreement")
    end

  end
end
