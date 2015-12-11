class RightsBackRequest < ActiveRecord::Base
  belongs_to :project

  after_initialize :custom_init

  def custom_init
    return if project.nil?

    self.title ||= (project.final_title) ? project.final_title : project.title
    self.author ||= project.authors.first.member.display_name
  end

end
