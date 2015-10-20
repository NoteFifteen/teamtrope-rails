class CoverConcept < ActiveRecord::Base
  include PaperclipS3UploadProcessing

  belongs_to :project

  has_attached_file :cover_concept, :s3_permissions => 'authenticated-read'
  has_attached_file :unapproved_cover_concept, :s3_permissions => 'authenticated-read'
  has_attached_file :stock_cover_image, :s3_permissions => 'authenticated-read'

  # Validates that files are JPEG
  validates_attachment :cover_concept,
                       *Constants::DefaultContentTypeImageParams

  validates_attachment :unapproved_cover_concept,
                       *Constants::DefaultContentTypeImageParams

  validates_attachment :stock_cover_image,
                       *Constants::ContentTypesStockCoverImageParams

  before_save :set_upload_attributes
  after_save :transfer_and_cleanup

  # if we find ourselves wanting to use this elsewhere, we should probably find it a better home...
  ImageSourceMap = {
    'shutterstock'      => 'Shutterstock',
    'dollarstock'       => 'Dollarstock Photo',
    'illustration'      => 'Illustration',
    'original'          => 'Original art from someone other than designer',
    'other'             => '<input id="cover_concept_image_source_other_input" name="cover_concept_image_source_other_input" type="text" size="200" value="Other">'.html_safe,
  }

  ConfirmationCheckboxes = {
    'can_be_used'    => 'By clicking this box, I confirm this art can be used by Booktrope for commercial purposes.',
    'fonts_licensed' => 'By clicking this box, I confirm all fonts used are licensed by cover designer for commercial use.',
  }

  # The following methods are to unescape the direct upload url path
  def cover_concept_image_direct_upload_url=(escaped_url)
    write_attribute(:cover_concept_image_direct_upload_url, self.unescape_url(escaped_url))
  end

  def stock_cover_image_direct_upload_url=(escaped_url)
    write_attribute(:stock_cover_image_direct_upload_url, self.unescape_url(escaped_url))
  end

  protected

  # Final upload processing step
  def transfer_and_cleanup
    transfer_and_cleanup_with_block do |type|
      if type == :cover_concept
        self.update_column(:cover_concept_image_processed, true)
      end

      if type == :stock_cover_image
        self.update_column(:stock_cover_image_processed, true)
      end
    end
  end

  def set_upload_attributes
    set_upload_attributes_with_block do |type, direct_upload_url_data, direct_upload_head|
      case(type)
        when :cover_concept
          self.cover_concept_file_name     = direct_upload_url_data[:filename]
          self.cover_concept_file_size     = direct_upload_head.content_length
          self.cover_concept_content_type  = direct_upload_head.content_type
          self.cover_concept_updated_at    = direct_upload_head.last_modified

        when :stock_cover_image
          self.stock_cover_image_file_name     = direct_upload_url_data[:filename]
          self.stock_cover_image_file_size     = direct_upload_head.content_length
          self.stock_cover_image_content_type  = direct_upload_head.content_type
          self.stock_cover_image_updated_at    = direct_upload_head.last_modified
      end
    end
  end

  def get_direct_upload_url
    if cover_concept_image_direct_upload_url_changed?
      return DIRECT_UPLOAD_URL_FORMAT.match(cover_concept_image_direct_upload_url)
    end

    if stock_cover_image_direct_upload_url_changed?
      return DIRECT_UPLOAD_URL_FORMAT.match(stock_cover_image_direct_upload_url)
    end
  end

  def get_uploaded_type
    if cover_concept_image_direct_upload_url_changed?
      return :cover_concept
    end
    if stock_cover_image_direct_upload_url_changed?
      return :stock_cover_image
    end
  end

end
