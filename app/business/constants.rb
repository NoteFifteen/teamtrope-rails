module Constants

  # Number of seconds a download link is good for after being issued
  DefaultLinkExpiration = 300

  # Number of seconds (31 days) a download ink is good for
  LinkExpirationOneMonth = 25920000

  DefaultSize = 0..120.megabytes
  DefaultSizeIn = { in: DefaultSize }

  # 500MB because that's the limit we use for S3 uploads
  # would be nice to coordinate these at some point
  MaxSize = 0..500.megabytes
  MaxSizeIn = { in: MaxSize }

  KdpSelectEnrollmentTerm = 90

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
    :file_name => { :matches => [/(epub|docx?)$/i] },
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

  DefaultContentTypeScreenshotParams = [
    :file_name => { :matches => [/(jpe?g|png)$/i] },
    :size => DefaultSizeIn
  ]

  DefaultContentTypePdfParams = [
    # :content_type => {
    #   content_type: 'application/pdf'
    # },
    :size => DefaultSizeIn
  ]

  # .ai is application/postscript...sigh
  DefaultContentTypeRawImageParams = [
    # These are commented out because this has not been reliable in the past.
    # :content_type => { content_type: ['image/vnd.adobe.photoshop', 'application/postscript', 'application/x-photoshop'] },
    :file_name => { :matches => [/(psd|ai|zip)$/i] },
    :size => MaxSizeIn
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

  MasterMetadataHeaderHash  = {
      project_id: "Project ID",
      prefunk: "Prefunk",
      prefunk_enrollment_date: "Prefunk Enrollment Date",
      title: "Title",
      series_name: "Series Name",
      series_number: "Series Number",
      author_last_first: "Author (Last,First)",
      author_first_last: "Author (First,Last)",
      pfs_author_name: "PFS Author Name",
      other_contributors: "Other Contributors",
      team_and_pct: "Team and Pct",
      imprint: "Imprint",
      asin: "ASIN",
      print_isbn: "Print ISBN",
      epub_isbn: "epub ISBN",
      format: "Format",
      publication_date: "Publication Date",
      month: "Month",
      year: "Year",
      page_count: "Page Count",
      print_price: "Print Price",
      ebook_price: "Ebook Price(Will vary based on promos and price changes)",
      library_price: "Library Price",
      bisac_one: "BISAC",
      bisac_one_description: "BISAC Description",
      bisac_two: "BISAC2",
      bisac_two_description: "BISAC Description 2",
      bisac_three: "BISAC3",
      bisac_three_description: "BISAC Description 3",
      search_terms: "Search Terms",
      summary: "Summary",
      author_bio: "Author Bio",
      squib: "Squib",
      authors_pct: "Authors & Pct",
      editors_pct: "Editors & Pct",
      book_managers_pct: "Book Managers & Pct",
      cover_designers_pct: "Cover Designers & Pct",
      project_managers_pct: "Project Managers & Pct",
      proofreaders_pct: "Proofreaders & Pct",
      total_pct: "Total PCT"

  }

  ScribdCsvHeaderHash = { project_id: "Project Id", imprint: "Imprint", parent_isbn: "Parent ISBN", ebook_isbn: "Ebook ISBN", format: "Format",
    filename:"Filename", title: "Title", subtitle: "Sub-title", authors: "Author(s)", publication_date: "Publication Date",
    street_date: "Street Date", digital_list_price: "Digital List Price", currency: "Currency", permitted_sales_territories: "Permitted Sales Territories",
    excluded_sales_territories: "Excluded Sales Territories", short_description: "Short Description", bisac_categories: "BISAC Categories",
    number_of_pages: "Number of Pages", series: "Series", delete: "Delete", direct_purchase: "Direct Purchase", subscription: "Subscription",
    preview_percent: "Preview %", language: "Language", genre: "Genre", enrollment_date: "Enrollment Date", asin: "ASIN", amazon_link: "Amazon Link", apple_id: "Apple ID" }

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
    all: { label: 'All Projects', task_name: '', workflow_name: '' },
    manuscript_development: { label: '', task_name: 'Manuscript Development', workflow_name: 'production' },
    upload_layout: { label: '', task_name: 'Upload Layout', workflow_name: 'production' },
    approve_cover: { label: 'Approve Cover', task_name: 'Approve Final Covers', workflow_name: 'design' },
    approve_blurb: { label: '', task_name: 'Approve Blurb', workflow_name: 'marketing' },
    page_count: { label: '', task_name: 'Page Count', workflow_name: 'production' },
    final_manuscript: { label: '', task_name: 'Final Manuscript', workflow_name: 'production' },
    publish_book: { label: '', task_name: 'Publish Book', workflow_name: 'production' }
  }

  # only change the task_name if the task name in the database has been changed.
  # use the label to override what appears in the dropdown navigation.
  ProjectsIndexFilters = {
    my_books: { label: 'My Books', task_name: '', workflow_name: '', required_roles: [] },
    original_manuscript: { label: '', task_name: 'Original Manuscript', workflow_name: 'production', required_roles: [] },
    in_editing: { label: 'In Editing', task_name: 'Edited Manuscript', workflow_name: 'production', required_roles: [] },
    in_proofreading: { label: 'In Proofreading', task_name: 'Proofread Complete', workflow_name: 'production', required_roles: [] },
    published: { label: 'Published', task_name: 'Production Complete', workflow_name: 'production', required_roles: [] },
    not_published: { label: 'Not Published', task_name: 'Production Complete', workflow_name: 'production', required_roles: [] },
    choose_style: { label: '', task_name: 'Choose Style', workflow_name: 'production', required_roles: [] },
  }

end
