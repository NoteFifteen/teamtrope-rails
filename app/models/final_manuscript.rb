class FinalManuscript < ActiveRecord::Base
  include PaperclipS3UploadProcessing

  belongs_to :project
  
  has_attached_file :pdf, preserve_files: true, :s3_permissions => 'authenticated-read'
  has_attached_file :doc, preserve_files: true, :s3_permissions => 'authenticated-read'

  validates_attachment :pdf,
  	*Constants::DefaultContentTypePdfParams
  	
  validates_attachment :doc, 
  	*Constants::DefaultContentTypeDocumentParams

  before_save :set_upload_attributes
  after_save :transfer_and_cleanup

  # The following methods are to unescape the direct upload url path
  def pdf_direct_upload_url=(escaped_url)
    write_attribute(:pdf_direct_upload_url, self.unescape_url(escaped_url))
  end

  def doc_direct_upload_url=(escaped_url)
    write_attribute(:doc_direct_upload_url, self.unescape_url(escaped_url))
  end

  protected

  # Final upload processing step
  def transfer_and_cleanup
    transfer_and_cleanup_with_block do |type|
      if type == :pdf
        self.update_column(:pdf_processed, true)
      end

      if type == :doc
        self.update_column(:doc_processed, true)
      end
    end
  end

  # Set attachment attributes from the direct upload
  def set_upload_attributes
    set_upload_attributes_with_block do |type, direct_upload_url_data, direct_upload_head|
      case(type)
        when :pdf
          self.pdf_file_name     = direct_upload_url_data[:filename]
          self.pdf_file_size     = direct_upload_head.content_length
          self.pdf_content_type  = direct_upload_head.content_type
          self.pdf_updated_at    = direct_upload_head.last_modified
        when :doc
          self.doc_file_name     = direct_upload_url_data[:filename]
          self.doc_file_size     = direct_upload_head.content_length
          self.doc_content_type  = direct_upload_head.content_type
          self.doc_updated_at    = direct_upload_head.last_modified
      end
    end
  end

  def get_direct_upload_url
    if pdf_direct_upload_url_changed?
      return DIRECT_UPLOAD_URL_FORMAT.match(pdf_direct_upload_url)
    end

    if doc_direct_upload_url_changed?
      return DIRECT_UPLOAD_URL_FORMAT.match(doc_direct_upload_url)
    end
  end

  def get_uploaded_type
    if pdf_direct_upload_url_changed?
      return :pdf
    end
    if doc_direct_upload_url_changed?
      return :doc
    end
  end

end
