class Layout < ActiveRecord::Base
  belongs_to :project

  include PaperclipS3UploadProcessing

  has_attached_file :layout_upload, :s3_permissions => 'authenticated-read'

  validates_attachment :layout_upload,
    *Constants::DefaultContentTypePdfParams

  # Available options for the layout style form -> layout style. Stored in 'layout_style_choice'
  LayoutStyleFonts = [['Cambria'], ['Covington'], ['Headline Two Exp'],['Letter Gothic'],['Lobster'],['Lucida Fax'],['M V Boli']]

  # Available options for the layout style -> Left Side Page Header Display - Name.  Stored in page_header_display_name
  PageHeaderDisplayNameChoices = [['Full Name'], ['Last Name Only']]

  TrimSizes = [['5.25 x 8', '5.25,8.0'],['5.5 x 8.5', '5.5,8.5'], ['5 x 8', '5.0,8.0'], ['6 x 9','6.0,9.0'], ['Other', 'other']]

  before_create :set_upload_attributes
  after_save :transfer_and_cleanup


  def trim_size
    if trim_size_w && trim_size_h
      "#{trim_size_w},#{trim_size_h}"
    else
      ""
    end
  end

  def trim_size=(size)
    unless size.nil? || !size.include?(",")
      trim = size.split(",")
      self.trim_size_w = trim[0].to_f
      self.trim_size_h = trim[1].to_f
    end
  end

  # The following methods are to unescape the direct upload url path
  def layout_upload_direct_upload_url=(escaped_url)
    write_attribute :layout_upload_direct_upload_url, self.unescape_url(escaped_url)
  end

  # Final upload processing step
  def transfer_and_cleanup
    transfer_and_cleanup_with_block do | type |
      case type
      when :layout_upload
        self.update_column :layout_upload_processed, true
      end
    end
  end

  def set_upload_attributes
    set_upload_attributes_with_block do | type, direct_upload_url_data, direct_upload_head |
      case type
      when :layout_upload
        self.layout_upload_file_name = direct_upload_url_data[:filename]
        self.layout_upload_file_size = direct_upload_head.content_length
        self.layout_upload_content_type = direct_upload_head.content_type
        self.layout_upload_updated_at = direct_upload_head.last_modified
      end
    end
  end

  def get_direct_upload_url
    if layout_upload_direct_upload_url_changed?
      return DIRECT_UPLOAD_URL_FORMAT.match(layout_upload_direct_upload_url)
    end
  end

  def get_uploaded_type
    if layout_upload_direct_upload_url_changed?
      return :layout_upload
    end
  end

end
