class EbookOnlyIncentive < ActiveRecord::Base
  belongs_to :project

  after_initialize :custom_init

  delegate :imprint_name, to: :project, allow_nil: true

  alias :imprint :imprint_name

  def custom_init
    return if project.nil?

    self.title ||= project.book_title
    self.author_name ||= project.authors.first.try(:member).try(:name)
    self.retail_price ||= project.try(:publication_fact_sheet).try(:ebook_price)
    self.publication_date ||= project.try(:published_file).try(:publication_date)
    self.isbn ||= project.try(:control_number).try(:epub_isbn)
    self.blurb ||= project.try(:draft_blurb).try(:draft_blurb)
    self.book_manager ||= project.book_managers.map{ |tm| tm.member.name}.join(", ")
  end
end
