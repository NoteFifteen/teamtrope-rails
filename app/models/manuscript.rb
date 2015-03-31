class Manuscript < ActiveRecord::Base
  belongs_to :project
  
  has_attached_file :original, preserve_files: true,
                    :s3_permissions => 'authenticated-read'

  has_attached_file :edited, preserve_files: true,
                    :s3_permissions => 'authenticated-read'

  has_attached_file :proofed, preserve_files: true,
                    :s3_permissions => 'authenticated-read'

  validates_attachment :original,
  	*Constants::DefaultContentTypeDocumentParams
  	
  validates_attachment :edited, 
  	*Constants::DefaultContentTypeDocumentParams
  	
  validates_attachment :proofed,
  	*Constants::DefaultContentTypeDocumentParams
end
