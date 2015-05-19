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
    # :content_type => {
    #   content_type: ['application/epub\+zip', 'application/octet-stream', 'text/plain']
    # },
    :file_name => { :matches => [/epub$/i] },
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
    manuscript_development: { task_name: 'Manuscript Development', workflow_name: 'production' },
    upload_layout: { task_name: 'Upload Layout', workflow_name: 'design' },
    approve_cover: { task_name: 'Approve Cover', workflow_name: 'marketing' },
    approve_blurb: { task_name: 'Approve Blurb', workflow_name: 'marketing' },
    page_count: { task_name: 'Page Count', workflow_name: 'production' },
    final_manuscript: { task_name: 'Final Manuscript', workflow_name: 'production' },
    publish_book: { task_name: 'Publish Book', workflow_name: 'production' }
  }


  ProjectsIndexFilters = {
    all: '',
    original_manuscript: { task_name: 'Original Manuscript', workflow_name: 'production' },
    submit_blurb: { task_name: 'Submit Blurb', workflow_name: 'marketing' },
    cover_concept: { task_name: 'Cover Concept', workflow_name: 'design' },
    in_editing: { task_name: 'Edited Manuscript', workflow_name: 'production' },
    in_proofreading: { task_name: 'Proofread Complete', workflow_name: 'production' },
    choose_style: { task_name: 'Choose Style', workflow_name: 'design' },
    final_covers: { task_name: 'Final Covers', workflow_name: 'design' },
    submit_pfs: { task_name: 'Submit PFS', workflow_name: 'marketing' },
    published: { task_name: 'Production Complete', workflow_name: 'production'}
  }

end
