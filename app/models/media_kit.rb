class MediaKit < ActiveRecord::Base
  belongs_to :project
  
  has_attached_file :document
  	
  validates_attachment :document, 
  	:content_type => { 
  		content_type: [ 
  				'application/pdf',
  				'application/msword',
  				'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  		]
  	},
  	:size => { :in => 0..120.megabytes } 	
  	
end
