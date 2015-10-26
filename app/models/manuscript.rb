class Manuscript < ActiveRecord::Base
  include PaperclipS3UploadProcessing

  belongs_to :project

  has_attached_file :original, preserve_files: true,
                    :s3_permissions => 'authenticated-read'

  has_attached_file :first_pass_edit, preserve_files: true,
                    :s3_permissions => 'authenticated-read'

  has_attached_file :edited, preserve_files: true,
                    :s3_permissions => 'authenticated-read'

  has_attached_file :proofed, preserve_files: true,
                    :s3_permissions => 'authenticated-read'

  has_attached_file :proofread_complete, preserve_files: true,
                    :s3_permissions => 'authenticated-read'

  validates_attachment :original,
    *Constants::DefaultContentTypeDocumentParams

  validates_attachment :first_pass_edit,
    *Constants::DefaultContentTypeDocumentParams

  validates_attachment :edited,
    *Constants::DefaultContentTypeDocumentParams

  validates_attachment :proofed,
    *Constants::DefaultContentTypeDocumentParams

  validates_attachment :proofread_complete,
    *Constants::DefaultContentTypeDocumentParams

  before_save :set_upload_attributes
  after_save :transfer_and_cleanup

  MANUSCRIPT_VERSIONS = ['original', 'first_pass_edit', 'edited', 'proofed', 'proofread_complete']

  # The following methods are to unescape the direct upload url path
  def original_file_direct_upload_url=(escaped_url)
    write_attribute(:original_file_direct_upload_url, self.unescape_url(escaped_url))
  end

  def first_pass_edit_direct_upload_url=(escaped_url)
    write_attribute(:first_pass_edit_direct_upload_url, self.unescape_url(escaped_url))
  end

  def edited_file_direct_upload_url=(escaped_url)
    write_attribute(:edited_file_direct_upload_url, self.unescape_url(escaped_url))
  end

  def proofed_file_direct_upload_url=(escaped_url)
    write_attribute(:proofed_file_direct_upload_url, self.unescape_url(escaped_url))
  end

  def proofread_complete_file_direct_upload_url=(escaped_url)
    write_attribute(:proofread_complete_file_direct_upload_url, self.unescape_url(escaped_url))
  end

  protected

  # Final upload processing step
  def transfer_and_cleanup
    transfer_and_cleanup_with_block do |type|
      self.update_column("#{type.to_s}_file_processed".to_sym, true)
    end
  end

  def set_upload_attributes
    set_upload_attributes_with_block do |type, direct_upload_url_data, direct_upload_head|
      update_column("#{type.to_s}_file_name".to_sym,    direct_upload_url_data[:filename])
      update_column("#{type.to_s}_file_size".to_sym,    direct_upload_head.content_length.to_i)
      update_column("#{type.to_s}_content_type".to_sym, direct_upload_head.content_type)
      update_column("#{type.to_s}_updated_at".to_sym,   direct_upload_head.last_modified)
    end
  end

  def get_direct_upload_url
    MANUSCRIPT_VERSIONS.each do |version|
      if self.send("#{version}_file_direct_upload_url_changed?")
        return DIRECT_UPLOAD_URL_FORMAT.match(self.send("#{version}_file_direct_upload_url"))
      end
    end
  end

  def get_uploaded_type
    MANUSCRIPT_VERSIONS.each do |version|
      if self.send("#{version}_file_direct_upload_url_changed?")
        return version.to_sym
      end
    end
  end

end
