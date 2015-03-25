class Manuscript < ActiveRecord::Base
  belongs_to :project
  
  has_attached_file :original, preserve_files: true
  has_attached_file :edited, preserve_files: true
  has_attached_file :proofed, preserve_files: true
  
  validates_attachment :original, 
  	*Constants::DefaultContentTypeDocumentParams
  	
  validates_attachment :edited, 
  	*Constants::DefaultContentTypeDocumentParams
  	
  validates_attachment :proofed,
  	*Constants::DefaultContentTypeDocumentParams  	  	
  
end
