class Layout < ActiveRecord::Base
  belongs_to :project

  has_attached_file :layout_upload, :s3_permissions => 'authenticated-read'

  validates_attachment :layout_upload,
    *Constants::DefaultContentTypePdfParams

  # Available options for the layout style form -> layout style. Stored in 'layout_style_choice'
  LayoutStyleFonts = [['Cambria'], ['Covington'], ['Headline Two Exp'],['Letter Gothic'],['Lobster'],['Lucida Fax'],['M V Boli']]

  # Available options for the layout style -> Left Side Page Header Display - Name.  Stored in page_header_display_name
  PageHeaderDisplayNameChoices = [['Full Name'], ['Last Name Only']]


end
