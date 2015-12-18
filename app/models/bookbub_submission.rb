class BookbubSubmission < ActiveRecord::Base
  belongs_to :project

  after_initialize :custom_init

  def custom_init
    return if project.nil?

    self.title ||= project.book_title
    self.author ||= project.authors.first.member.display_name
    self.asin ||= project.try(:control_number).try(:asin)
    self.current_price ||= project.try(:publication_fact_sheet).try(:ebook_price)
    self.num_pages ||= project.try(:layout).try(:final_page_count)

  end

end
