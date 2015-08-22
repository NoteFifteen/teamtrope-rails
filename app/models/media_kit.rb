class MediaKit < ActiveRecord::Base
  include PaperclipS3UploadProcessing

  belongs_to :project

  has_attached_file :document, :s3_permissions => 'authenticated-read'

  # using the splat operator to pass the array of params returned from
  # attachment_validation_params to validates_attachment
  validates_attachment :document,
    *(Constants::attachment_validation_params(
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  ))

  before_save :set_upload_attributes
  after_save :transfer_and_cleanup

  def document_direct_upload_url=(escaped_url)
    write_attribute(:document_direct_upload_url, self.unescape_url(escaped_url))
  end

  def transfer_and_cleanup
    transfer_and_cleanup_with_block do | type |
      if type == :document
        self.update_column(:document_processed, true)
      end
    end
  end

  def set_upload_attributes
    set_upload_attributes_with_block do | type, direct_upload_url, direct_upload_head |
      case type
      when :document
        self.document_file_name    = direct_upload_url[:filename]
        self.document_file_size    = direct_upload_head.content_length
        self.document_content_type = direct_upload_head.content_type
        self.document_updated_at   = direct_upload_head.last_modified
      end
    end
  end

  def get_direct_upload_url
    if document_direct_upload_url_changed?
      return DIRECT_UPLOAD_URL_FORMAT.match(document_direct_upload_url)
    end
  end

  def get_uploaded_type
    if document_direct_upload_url_changed?
      return :document
    end
  end

end
