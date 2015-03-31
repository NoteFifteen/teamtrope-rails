class MediaKit < ActiveRecord::Base
  belongs_to :project
  
  has_attached_file :document, :s3_permissions => 'authenticated-read'
  
  # using the splat operator to pass the array of params returned from
  # attachment_validation_params to validates_attachment
  validates_attachment :document, 
  	*(Constants::attachment_validation_params(
  	'application/pdf',
  	'application/msword',
  	'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  ))
  	
end
