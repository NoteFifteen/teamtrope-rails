class Manuscript < ActiveRecord::Base
  include PaperclipS3UploadProcessing

  belongs_to :project

  has_attached_file :original, preserve_files: true,
                    :s3_permissions => 'authenticated-read'

  has_attached_file :edited, preserve_files: true,
                    :s3_permissions => 'authenticated-read'

  has_attached_file :proofread_reviewed, preserve_files: true,
                    s3_permissions: 'authenticated-read'

  has_attached_file :proofed, preserve_files: true,
                    :s3_permissions => 'authenticated-read'

  validates_attachment :original,
  	*Constants::DefaultContentTypeDocumentParams

  validates_attachment :edited,
  	*Constants::DefaultContentTypeDocumentParams

  validates_attachment :proofread_reviewed,
    *Constants::DefaultContentTypeDocumentParams

  validates_attachment :proofed,
  	*Constants::DefaultContentTypeDocumentParams

  before_save :set_upload_attributes
  after_save :transfer_and_cleanup

  # The following methods are to unescape the direct upload url path
  def original_file_direct_upload_url=(escaped_url)
    write_attribute(:original_file_direct_upload_url, self.unescape_url(escaped_url))
  end

  def edited_file_direct_upload_url=(escaped_url)
    write_attribute(:edited_file_direct_upload_url, self.unescape_url(escaped_url))
  end

  def proofread_reviewed_file_direct_upload_url=(escaped_url)
    write_attribute(:proofread_reviewed_file_direct_upload_url, self.unescape_url(escaped_url))
  end

  def proofed_file_direct_upload_url=(escaped_url)
    write_attribute(:proofed_file_direct_upload_url, self.unescape_url(escaped_url))
  end

  protected

  # Final upload processing step
  def transfer_and_cleanup
    transfer_and_cleanup_with_block do |type|
      if type == :original
        self.update_column(:original_file_processed, true)
      end

      if type == :edited
        self.update_column(:edited_file_processed, true)
      end

      if type == :proofread_reviewed
        self.update_column(:proofread_reviewed_file_processed, true)
      end

      if type == :proofed
        self.update_column(:proofed_file_processed, true)
      end
    end
  end

  def set_upload_attributes
    set_upload_attributes_with_block do |type, direct_upload_url_data, direct_upload_head|
      case(type)
        when :original
          self.original_file_name     = direct_upload_url_data[:filename]
          self.original_file_size     = direct_upload_head.content_length
          self.original_content_type  = direct_upload_head.content_type
          self.original_updated_at    = direct_upload_head.last_modified

        when :edited
          self.edited_file_name     = direct_upload_url_data[:filename]
          self.edited_file_size     = direct_upload_head.content_length
          self.edited_content_type  = direct_upload_head.content_type
          self.edited_updated_at    = direct_upload_head.last_modified

        when :proofread_reviewed
          self.proofread_reviewed_file_name     = direct_upload_url_data[:filename]
          self.proofread_reviewed_file_size     = direct_upload_head.content_length
          self.proofread_reviewed_content_type  = direct_upload_head.content_type
          self.proofread_reviewed_updated_at    = direct_upload_head.last_modified

        when :proofed
          self.proofed_file_name     = direct_upload_url_data[:filename]
          self.proofed_file_size     = direct_upload_head.content_length
          self.proofed_content_type  = direct_upload_head.content_type
          self.proofed_updated_at    = direct_upload_head.last_modified
      end
    end
  end

  def get_direct_upload_url
    if original_file_direct_upload_url_changed?
      return DIRECT_UPLOAD_URL_FORMAT.match(original_file_direct_upload_url)
    end

    if edited_file_direct_upload_url_changed?
      return DIRECT_UPLOAD_URL_FORMAT.match(edited_file_direct_upload_url)
    end

    if proofread_reviewed_file_direct_upload_url_changed?
      return DIRECT_UPLOAD_URL_FORMAT.match(proofread_reviewed_file_direct_upload_url)
    end

    if proofed_file_direct_upload_url_changed?
      return DIRECT_UPLOAD_URL_FORMAT.match(proofed_file_direct_upload_url)
    end
  end

  def get_uploaded_type
    if original_file_direct_upload_url_changed?
      return :original
    end
    if edited_file_direct_upload_url_changed?
      return :edited
    end

    if proofread_reviewed_file_direct_upload_url_changed?
      return :proofread_reviewed
    end

    if proofed_file_direct_upload_url_changed?
      return :proofed
    end
  end

end
