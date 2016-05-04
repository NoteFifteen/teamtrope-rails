class ImportedContract < ActiveRecord::Base
  include PaperclipS3UploadProcessing

  belongs_to :project

  Document_Types = Hash[*["Author Agreement","author_agreement","CTA","cta","Other","other"]]


  has_attached_file :contract, preserve_files: true,
                    :s3_permissions => 'authenticated-read'

  validates_attachment :contract,
        :content_type => {
          content_type: [
            'application/msword',
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            'application/pdf',
            'text/plain'
          ]
        }
        # *Constants::DefaultContentTypeDocumentParams

  before_save :set_upload_attributes
  after_save :transfer_and_cleanup

  # The following methods are to unescape the direct upload url path
  def contract_direct_upload_url=(escaped_url)
    write_attribute(:contract_direct_upload_url, self.unescape_url(escaped_url))
  end

  def signers
    @signers ||= User.find(document_signers)
  end

  protected

  # Final upload processing step
  def transfer_and_cleanup
    transfer_and_cleanup_with_block do |type|
      if type == :contract
        self.update_column(:contract_processed, true)
      end
    end
  end

  def set_upload_attributes
    set_upload_attributes_with_block do |type, direct_upload_url_data, direct_upload_head|
      case(type)
      when :contract
        self.contract_file_name     = direct_upload_url_data[:filename]
        self.contract_file_size     = direct_upload_head.content_length
        self.contract_content_type  = direct_upload_head.content_type
        self.contract_updated_at    = direct_upload_head.last_modified
      end
    end
  end

  def get_direct_upload_url
    if contract_direct_upload_url_changed?
      return DIRECT_UPLOAD_URL_FORMAT.match(contract_direct_upload_url)
    end
  end

  def get_uploaded_type
    if contract_direct_upload_url_changed?
      return :contract
    end
  end

end
