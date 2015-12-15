class EbookOnlyIncentive < ActiveRecord::Base
  belongs_to :project

  after_initialize :custom_init

  delegate :imprint_name, to: :project, allow_nil: true

  alias :imprint :imprint_name

  def custom_init
    return if project.nil?

    self.title ||= project.final_title
    self.author_name ||= project.authors.first.member.display_name
    self.retail_price ||= project.publication_fact_sheet.ebook_price
    self.publication_date ||= project.published_file.publication_date
    self.isbn ||= project.try(:control_number).try(:epub_isbn)
    self.blurb ||= project.try(:draft_blurb).try(:draft_blurb)
  end
end
