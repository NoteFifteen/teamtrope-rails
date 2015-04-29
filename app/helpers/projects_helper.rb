module ProjectsHelper

  def get_projects_for_index(filter_by)

    @grid_title = "The Grid"
    unless filter_by.nil? || !Constants::ProjectsIndexFilters.has_key?(filter_by.to_sym)
      @grid_title = Constants::ProjectsIndexFilters[filter_by.to_sym]
      @projects = Project.projects_with_task(@grid_title).page(params[:page])
    else
      @projects = Project.order(title: :asc).includes(:team_memberships => [:member, :role]).page(params[:page])
    end
  end
end
