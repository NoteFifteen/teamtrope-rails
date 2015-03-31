module Constants

  # Number of seconds a download link is good for after being issued
  DefaultLinkExpiration = 10

  DefaultSize = 0..120.megabytes
  DefaultSizeIn = { in: DefaultSize }
    
  DefaultContentTypeDocumentParams = [
  	:content_type => { 
  		content_type: [ 'application/msword',
  				'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  			] 
  	}, 
  	:size => DefaultSizeIn
  ]

	DefaultContentTypeEpubParams = [
		:content_type => {
			content_type: 'application/epub+zip'
		},
		:size => DefaultSizeIn
	]
  
	DefaultContentTypeMobiParams = [
		:content_type => {
			content_type: 'application/octet-stream'
		},
		:size => DefaultSizeIn
	]

  DefaultContentTypeImageParams = [
  	:content_type => { content_type: ['image/jpeg', 'image/pjpeg'] },
    :file_name => { :matches => [/jpe?g\Z/] },
  	:size => DefaultSizeIn
  ]
  	
  DefaultContentTypePdfParams = [
  	:content_type => {
  		content_type: 'application/pdf'
  	},
  	:size => DefaultSizeIn
  ]
  
  def Constants.attachment_validation_params(*content_type, size: DefaultSize)
	  [
  		:content_type => {
  			content_type: content_type
	  	},
  		:size => { in: size }
	  ]
  end
	
end