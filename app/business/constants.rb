module Constants

  # Number of seconds a download link is good for after being issued
  DefaultLinkExpiration = 300

  # Number of seconds (31 days) a download ink is good for
  LinkExpirationOneMonth = 25920000

  DefaultSize = 0..120.megabytes
  DefaultSizeIn = { in: DefaultSize }

  DefaultContentTypeDocumentParams = [
    # TTR-62 - Removing the mime-type validation due to user issues with uploading manuscripts
    # :content_type => {
    #   content_type: [
    #       'application/msword',
    #       'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    #       'application/pdf',
    #       'text/plain'
    #     ]
    # },
    # :file_name => { :matches => [/doc?x$/i] },
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
    # :content_type => {
    #   content_type: ['application/octet-stream', 'text/plain']
    # },
    :file_name => { :matches => [/mobi$/i] },
    :size => DefaultSizeIn
  ]

  DefaultContentTypeImageParams = [
    :content_type => { content_type: ['image/jpeg', 'image/pjpeg', 'application/pdf'] },
    :file_name => { :matches => [/jpe?g\Z/i] },
    :size => DefaultSizeIn
  ]

  DefaultContentTypePdfParams = [
    # :content_type => {
    #   content_type: 'application/pdf'
    # },
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
      :content_type => { content_type: ['application/zip', 'image/jpeg', 'image/pjpeg', 'image/png'] },
      :file_name => { :matches => [/jpe?g$|png|zip$/i] },
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

  # only change the task_name if the task name in the database has been changed.
  # use the label to override what appears in the dropdown navigation.
  AdminProjectsIndexFilters = {
    manuscript_development: { label: '', task_name: 'Manuscript Development', workflow_name: 'production' },
    upload_layout: { label: '', task_name: 'Upload Layout', workflow_name: 'design' },
    approve_cover: { label: '', task_name: 'Approve Cover', workflow_name: 'marketing' },
    approve_blurb: { label: '', task_name: 'Approve Blurb', workflow_name: 'marketing' },
    page_count: { label: '', task_name: 'Page Count', workflow_name: 'production' },
    final_manuscript: { label: '', task_name: 'Final Manuscript', workflow_name: 'production' },
    publish_book: { label: '', task_name: 'Publish Book', workflow_name: 'production' }
  }

  # only change the task_name if the task name in the database has been changed.
  # use the label to override what appears in the dropdown navigation.
  ProjectsIndexFilters = {
    my_books: { label: 'My Books', task_name: '', workflow_name: '' },
    original_manuscript: { label: '', task_name: 'Original Manuscript', workflow_name: 'production' },
    submit_blurb: { label: '', task_name: 'Submit Blurb', workflow_name: 'marketing' },
    cover_concept: { label: '', task_name: 'Cover Concept', workflow_name: 'design' },
    in_editing: { label: 'In Editing', task_name: 'Edited Manuscript', workflow_name: 'production' },
    in_proofreading: { label: 'In Proofreading', task_name: 'Proofread Complete', workflow_name: 'production' },
    choose_style: { label: '', task_name: 'Choose Style', workflow_name: 'design' },
    final_covers: { label: '', task_name: 'Final Covers', workflow_name: 'design' },
    submit_pfs: { label: '', task_name: 'Submit PFS', workflow_name: 'marketing' },
    published: { label: 'Published', task_name: 'Production Complete', workflow_name: 'production'},
    all: { label: 'All Projects', task_name: '', workflow_name: '' }
  }

end
