class FinalManuscript < ActiveRecord::Base
  belongs_to :project
  
  has_attached_file :pdf, preserve_files: true, :s3_permissions => 'authenticated-read'
  has_attached_file :doc, preserve_files: true, :s3_permissions => 'authenticated-read'
  
  validates_attachment :pdf, 
  	*Constants::DefaultContentTypePdfParams
  	
  validates_attachment :doc, 
  	*Constants::DefaultContentTypeDocumentParams  
  
end
