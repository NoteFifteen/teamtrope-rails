module ProjectsHelper

  def get_projects_for_index(filter_by)
    filters = Constants::ProjectsIndexFilters
    filters = filters.merge(Constants::AdminProjectsIndexFilters) if current_user.role? :booktrope_staff
    @grid_title = "The Grid"
    unless filter_by.nil? || !filters.has_key?(filter_by.to_sym)
      if filter_by.to_sym == :all
        @projects = ProjectGridTableRow.includes(:project).all
      else
        @grid_title =  filters[filter_by.to_sym][:label]
        @grid_title =  filters[filter_by.to_sym][:task_name] if @grid_title.empty?
        pgtr_meta_hash = filters[filter_by.to_sym]
        @projects = ProjectGridTableRow.includes(:project).where("#{pgtr_meta_hash[:workflow_name]}_task_name = ?", pgtr_meta_hash[:task_name])
      end
    else
      @grid_title = "My Books"
      # We only want the book to show up once in the list so we use distinct.
      @projects = ProjectGridTableRow.where(project_id: current_user.projects.ids).distinct
    end
  end
end
