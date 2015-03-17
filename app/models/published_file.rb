class PublishedFile < ActiveRecord::Base
  belongs_to :project
  
  has_attached_file :epub
  has_attached_file :mobi
  has_attached_file :pdf
  
  validates_attachment :epub,
  	*Constants::DefaultContentTypeEpubParams
  	
  validates_attachment :mobi,
  	*Constants::DefaultContentTypeMobiParams
  
  validates_attachment :pdf,
  	*Constants::DefaultContentTypePdfParams
  
end
