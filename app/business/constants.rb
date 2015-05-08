module Constants

  # Number of seconds a download link is good for after being issued
  DefaultLinkExpiration = 10

  DefaultSize = 0..120.megabytes
  DefaultSizeIn = { in: DefaultSize }

  DefaultContentTypeDocumentParams = [
    :content_type => {
      content_type: [ 'application/msword',
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
          'application/pdf',
          'text/plain'
        ]
    },
    :size => DefaultSizeIn
  ]

  DefaultContentTypeEpubParams = [
    :content_type => {
      content_type: ['application/epub\+zip', 'application/octet-stream', 'text/plain']
    },
    :size => DefaultSizeIn
  ]

  DefaultContentTypeMobiParams = [
    :content_type => {
      content_type: ['application/octet-stream', 'text/plain']
    },
    :size => DefaultSizeIn
  ]

  DefaultContentTypeImageParams = [
    :content_type => { content_type: ['image/jpeg', 'image/pjpeg', 'application/pdf'] },
    :file_name => { :matches => [/jpe?g\Z/i] },
    :size => DefaultSizeIn
  ]

  DefaultContentTypePdfParams = [
    :content_type => {
      content_type: 'application/pdf'
    },
    :size => DefaultSizeIn
  ]

  # For a pure zip file
  DefaultContentTypeZipParams = [
      :content_type => {
          content_type: 'application/zip'
      },
      :file_name => { :matches => [/zip$/i] },
      :size => DefaultSizeIn
  ]

  # Custom params for Stock Cover Image(s) since they're allowed to upload a zip file
  ContentTypesStockCoverImageParams = [
      :content_type => { content_type: ['application/zip', 'image/jpeg', 'image/pjpeg'] },
      :file_name => { :matches => [/jpe?g$|zip$/i] },
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

  AdminProjectsIndexFilters = {
    manuscript_development: 'Manuscript Development',
    upload_layout: 'Upload Layout',
    approve_cover: 'Approve Cover',
    approve_blurb: 'Approve Blurb',
    page_count: 'Page Count',
    final_manuscript: 'Final Manuscript',
    publish_book: 'Publish Book'
  }


  ProjectsIndexFilters = {
    original_manuscript: 'Original Manuscript',
    submit_blurb: 'Submit Blurb',
    cover_concept: 'Cover Concept',
    in_editing: 'Edited Manuscript',
    in_proofreading: 'Proofread Complete',
    choose_style: 'Choose Style',
    final_covers: 'Final Covers',
    submit_pfs: 'Submit PFS',
    published: 'Production Complete'
  }

end
