class FinalManuscript < ActiveRecord::Base
  belongs_to :project
  
  has_attached_file :pdf, preserve_files: true
  has_attached_file :doc, preserve_files: true
  
  validates_attachment :pdf, 
  	*Constants::DefaultContentTypePdfParams
  	
  validates_attachment :doc, 
  	*Constants::DefaultContentTypeDocumentParams  
  
end
