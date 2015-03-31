class PublishedFile < ActiveRecord::Base
  belongs_to :project
  
  has_attached_file :epub, :s3_permissions => 'authenticated-read'
  has_attached_file :mobi, :s3_permissions => 'authenticated-read'
  has_attached_file :pdf, :s3_permissions => 'authenticated-read'
  
  validates_attachment :epub,
  	*Constants::DefaultContentTypeEpubParams
  	
  validates_attachment :mobi,
  	*Constants::DefaultContentTypeMobiParams
  
  validates_attachment :pdf,
  	*Constants::DefaultContentTypePdfParams
  
end
