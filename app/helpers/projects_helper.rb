module ProjectsHelper

  def get_projects_for_index(filter_by)
    filters = Constants::ProjectsIndexFilters
    filters = filters.merge(Constants::AdminProjectsIndexFilters) if current_user.role? :booktrope_staff
    @grid_title = "The Grid"
    unless filter_by.nil? || !filters.has_key?(filter_by.to_sym)
      @grid_title = filters[filter_by.to_sym]
      @projects = Project.with_task(@grid_title).page(params[:page])
    else
      @projects = Project.order(title: :asc)
        .includes(:team_memberships => [:member, :role])
        .page(params[:page])
    end
  end
end
