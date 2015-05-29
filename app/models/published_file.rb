class PublishedFile < ActiveRecord::Base
  include PaperclipS3UploadProcessing

  belongs_to :project
  
  has_attached_file :epub, :s3_permissions => 'authenticated-read'
  has_attached_file :mobi, :s3_permissions => 'authenticated-read'
  has_attached_file :pdf,  :s3_permissions => 'authenticated-read'
  
  validates_attachment :epub,
  	*Constants::DefaultContentTypeEpubParams
  	
  validates_attachment :mobi,
  	*Constants::DefaultContentTypeMobiParams
  
  validates_attachment :pdf,
  	*Constants::DefaultContentTypePdfParams

  before_save :set_upload_attributes
  after_save :transfer_and_cleanup

  # The following methods are to unescape the direct upload url path
  def mobi_direct_upload_url=(escaped_url)
    write_attribute(:mobi_direct_upload_url, self.unescape_url(escaped_url))
  end

  def epub_direct_upload_url=(escaped_url)
    write_attribute(:epub_direct_upload_url, self.unescape_url(escaped_url))
  end

  def pdf_direct_upload_url=(escaped_url)
    write_attribute(:pdf_direct_upload_url, self.unescape_url(escaped_url))
  end

  protected

  # Final upload processing step
  def transfer_and_cleanup
    transfer_and_cleanup_with_block do |type|
      if type == :mobi
        self.update_column(:mobi_processed, true)
      end

      if type == :epub
        self.update_column(:epub_processed, true)
      end

      if type == :pdf
        self.update_column(:pdf_processed, true)
      end
    end
  end

  def set_upload_attributes
    set_upload_attributes_with_block do |type, direct_upload_url_data, direct_upload_head|
      case(type)
        when :mobi
          self.mobi_file_name     = direct_upload_url_data[:filename]
          self.mobi_file_size     = direct_upload_head.content_length
          self.mobi_content_type  = direct_upload_head.content_type
          self.mobi_updated_at    = direct_upload_head.last_modified

        when :epub
          self.epub_file_name     = direct_upload_url_data[:filename]
          self.epub_file_size     = direct_upload_head.content_length
          self.epub_content_type  = direct_upload_head.content_type
          self.epub_updated_at    = direct_upload_head.last_modified

        when :pdf
          self.pdf_file_name     = direct_upload_url_data[:filename]
          self.pdf_file_size     = direct_upload_head.content_length
          self.pdf_content_type  = direct_upload_head.content_type
          self.pdf_updated_at    = direct_upload_head.last_modified
      end
    end
  end

  def get_direct_upload_url
    if mobi_direct_upload_url_changed?
      return DIRECT_UPLOAD_URL_FORMAT.match(mobi_direct_upload_url)
    end

    if epub_direct_upload_url_changed?
      return DIRECT_UPLOAD_URL_FORMAT.match(epub_direct_upload_url)
    end

    if pdf_direct_upload_url_changed?
      return DIRECT_UPLOAD_URL_FORMAT.match(pdf_direct_upload_url)
    end

  end

  def get_uploaded_type
    if mobi_direct_upload_url_changed?
      return :mobi
    end
    if epub_direct_upload_url_changed?
      return :epub
    end
    if pdf_direct_upload_url_changed?
      return :pdf
    end
  end

end
