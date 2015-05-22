class FinalManuscript < ActiveRecord::Base

  # Environment-specific direct upload url verifier screens for malicious posted upload locations.

  # teamtrope-rails-testing vs teamtrope-com
  DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/teamtrope\-#{!Rails.env.production? ? "rails\-testing" : 'com'}\.s3\.amazonaws\.com\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze

  belongs_to :project
  
  has_attached_file :pdf, preserve_files: true, :s3_permissions => 'authenticated-read'
  has_attached_file :doc, preserve_files: true, :s3_permissions => 'authenticated-read'

  validates_attachment :pdf,
  	*Constants::DefaultContentTypePdfParams
  	
  validates_attachment :doc, 
  	*Constants::DefaultContentTypeDocumentParams

  before_create :set_upload_attributes
  after_create :transfer_and_cleanup

  # The following methods are to unescape the direct upload url path
  def pdf_direct_upload_url=(escaped_url)
    write_attribute(:pdf_direct_upload_url, self.unescape_url(escaped_url))
  end

  def doc_direct_upload_url=(escaped_url)
    write_attribute(:doc_direct_upload_url, self.unescape_url(escaped_url))
  end

  def unescape_url(escaped_url)
    CGI.unescape(escaped_url) rescue nil
  end

  # Final upload processing step
  def transfer_and_cleanup
    direct_upload_url_data = self.get_direct_upload_url
    s3 = AWS::S3.new

    paperclip_file_path = "documents/uploads/#{id}/original/#{direct_upload_url_data[:filename]}"
    s3.buckets[S3DirectUpload.config.bucket].objects[paperclip_file_path].copy_from(direct_upload_url_data[:path])

    if self.get_uploaded_type == :pdf
      self.pdf_processed = true
    end

    if self.get_uploaded_type == :doc
      self.doc_processed = true
    end

    self.save

    s3.buckets[S3DirectUpload.config.bucket].objects[direct_upload_url_data[:path]].delete
  end

  protected

  # Set attachment attributes from the direct upload
  # @note Retry logic handles S3 "eventual consistency" lag.
  def set_upload_attributes
    direct_upload_url_data = self.get_direct_upload_url

    tries ||= 5

    s3 = AWS::S3.new
    direct_upload_head = s3.buckets[S3DirectUpload.config.bucket].objects[direct_upload_url_data[:path]].head

    if self.get_uploaded_type == :pdf
      self.pdf_file_name     = direct_upload_url_data[:filename]
      self.pdf_file_size     = direct_upload_head.content_length
      self.pdf_content_type  = direct_upload_head.content_type
      self.pdf_updated_at    = direct_upload_head.last_modified
    end

    if self.get_uploaded_type == :doc
      self.doc_file_name     = direct_upload_url_data[:filename]
      self.doc_file_size     = direct_upload_head.content_length
      self.doc_content_type  = direct_upload_head.content_type
      self.doc_updated_at    = direct_upload_head.last_modified
    end

  rescue AWS::S3::Errors::NoSuchKey => e
    tries -= 1
    if tries > 0
      sleep(3)
      retry
    else
      false
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
