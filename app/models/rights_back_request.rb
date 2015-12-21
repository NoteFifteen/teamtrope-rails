class RightsBackRequest < ActiveRecord::Base
  belongs_to :project

  after_initialize :custom_init

  def custom_init
    return if project.nil?

    self.title ||= project.book_title
    self.author ||= project.authors.first.member.display_name
  end

end
