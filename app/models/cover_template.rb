class CoverTemplate < ActiveRecord::Base
  belongs_to :project

  include PaperclipS3UploadProcessing

  has_attached_file :alternative_cover, :s3_permissions => 'authenticated-read'
  has_attached_file :createspace_cover, :s3_permissions => 'authenticated-read'
  has_attached_file :ebook_front_cover, :s3_permissions => 'authenticated-read'
  has_attached_file :lightning_source_cover, :s3_permissions => 'authenticated-read'

  has_attached_file :cover_preview,
        :styles => { :large => "600x600>", :medium => "300x300>", :thumb => "120x120>"},
        :convert_options => { :large => "-quality 100", :medium => '-quality 100', :thumb => '-quality 100' },
        # :default_url => "/images/:style/missing.gif",
        :processors => [:cropper]

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  validates_attachment :alternative_cover,
    *Constants::DefaultContentTypePdfParams

  validates_attachment :createspace_cover,
    *Constants::DefaultContentTypePdfParams

  validates_attachment :lightning_source_cover,
    *Constants::DefaultContentTypePdfParams

  validates_attachment :ebook_front_cover,
    *Constants::DefaultContentTypeImageParams

  before_create :set_upload_attributes
  after_save :transfer_and_cleanup

  # The following methods are to unescape the direct upload url path
  def ebook_front_cover_direct_upload_url=(escaped_url)
    write_attribute :ebook_front_cover_direct_upload_url, self.unescape_url(escaped_url)
  end

  def createspace_cover_direct_upload_url=(escaped_url)
    write_attribute :createspace_cover_direct_upload_url, self.unescape_url(escaped_url)
  end

  def lightning_source_cover_direct_upload_url=(escaped_url)
    write_attribute :lightning_source_cover_direct_upload_url, self.unescape_url(escaped_url)
  end

  def alternative_cover_direct_upload_url=(escaped_url)
    write_attribute :alternative_cover_direct_upload_url, self.unescape_url(escaped_url)
  end

  # Final upload processing step
  def transfer_and_cleanup
    transfer_and_cleanup_with_block do | type |
      case type
      when :ebook_front_cover
        self.update_column :ebook_front_cover_processed, true
      when :createspace_cover
        self.update_column :createspace_cover_processed, true
      when :lightning_source_cover
        self.update_column :lightning_source_cover_processed, true
      when :alternative_cover
        self.update_column :alternative_cover_processed, true
      end
    end
  end

  def set_upload_attributes
    set_upload_attributes_with_block do | type, direct_upload_url_data, direct_upload_head |
      case(type)
      when :ebook_front_cover
        self.ebook_front_cover_file_name = direct_upload_url_data[:filename]
        self.ebook_front_cover_file_size = direct_upload_head.content_length
        self.ebook_front_cover_content_type = direct_upload_head.content_type
        self.ebook_front_cover_updated_at = direct_upload_head.last_modified
      when :createspace_cover
        self.createspace_cover_file_name = direct_upload_url_data[:filename]
        self.createspace_cover_file_size = direct_upload_head.content_length
        self.createspace_cover_content_type = direct_upload_head.content_type
        self.createspace_cover_updated_at = direct_upload_head.last_modified
      when :lightning_source_cover
        self.lightning_source_cover_file_name = direct_upload_url_data[:filename]
        self.lightning_source_cover_file_size = direct_upload_head.content_length
        self.lightning_source_cover_content_type = direct_upload_head.content_type
        self.lightning_source_cover_updated_at = direct_upload_head.last_modified
      when :alternative_cover
        self.alternative_cover_file_name = direct_upload_url_data[:filename]
        self.alternative_cover_file_size = direct_upload_head.content_length
        self.alternative_cover_content_type = direct_upload_head.content_type
        self.alternative_cover_updated_at = direct_upload_head.last_modified
      end
    end
  end

  def get_direct_upload_url
    if ebook_front_cover_direct_upload_url_changed?
      return DIRECT_UPLOAD_URL_FORMAT.match(ebook_front_cover_direct_upload_url)
    end

    if createspace_cover_direct_upload_url_changed?
      return DIRECT_UPLOAD_URL_FORMAT.match(createspace_cover_direct_upload_url)
    end

    if lightning_source_cover_direct_upload_url_changed?
      return DIRECT_UPLOAD_URL_FORMAT.match(lightning_source_cover_direct_upload_url)
    end

    if alternative_cover_direct_upload_url_changed?
      return DIRECT_UPLOAD_URL_FORMAT.match(alternative_cover_direct_upload_url)
    end

  end

  def get_uploaded_type
    if ebook_front_cover_direct_upload_url_changed?
      return :ebook_front_cover
    end

    if createspace_cover_direct_upload_url_changed?
      return :createspace_cover
    end

    if lightning_source_cover_direct_upload_url_changed?
      return :lightning_source_cover
    end

    if alternative_cover_direct_upload_url_changed?
      return :alternative_cover
    end

  end

end
