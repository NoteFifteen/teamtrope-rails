class CoverTemplate < ActiveRecord::Base
  belongs_to :project
  
  has_attached_file :alternative_cover, :s3_permissions => 'authenticated-read'
  has_attached_file :createspace_cover, :s3_permissions => 'authenticated-read'
  has_attached_file :ebook_front_cover, :s3_permissions => 'authenticated-read'
  has_attached_file :lightning_source_cover, :s3_permissions => 'authenticated-read'
  
  validates_attachment :alternative_cover,
  	*Constants::DefaultContentTypePdfParams
  	
  validates_attachment :createspace_cover,
  	*Constants::DefaultContentTypePdfParams
  
  validates_attachment :lightning_source_cover,
  	*Constants::DefaultContentTypePdfParams
  	
  validates_attachment :ebook_front_cover,
  	*Constants::DefaultContentTypeImageParams
  	  
end
