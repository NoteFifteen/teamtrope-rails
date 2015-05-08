module ProjectsHelper

  def get_projects_for_index(filter_by)
    filters = Constants::ProjectsIndexFilters
    filters = filters.merge(Constants::AdminProjectsIndexFilters) if current_user.role? :booktrope_staff
    @grid_title = "The Grid"
    unless filter_by.nil? || !filters.has_key?(filter_by.to_sym)
      @grid_title =  filter_by.to_s.humanize.gsub(/_/," ")
      @projects = Project.with_task(filters[filter_by.to_sym])
      @projects = @projects.page(params[:page]) if @projects.count > 500
    else
      @projects = Project.order(title: :asc)
        .includes(:team_memberships => [:member, :role])
      @projects = @projects.page(params[:page]) if @projects.count > 500
    end
  end
end
