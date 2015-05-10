module ProjectsHelper

  def get_projects_for_index(filter_by)
    filters = Constants::ProjectsIndexFilters
    filters = filters.merge(Constants::AdminProjectsIndexFilters) if current_user.role? :booktrope_staff
    @grid_title = "The Grid"
    unless filter_by.nil? || !filters.has_key?(filter_by.to_sym)
      if filter_by.to_sym == :all
        @projects = Project.page(params[:page]) if Project.count > 500
        @projects ||= Project.all
      else
        @grid_title =  filter_by.to_s.humanize.gsub(/_/," ")
        @projects = Project.with_task(filters[filter_by.to_sym])
        @projects = @projects.page(params[:page]) if @projects.count > 500
      end
    else
      @grid_title = "My Books"
      # We only want the book to show up once in the list so we use distinct.
      @projects = current_user.projects.order(title: :asc).distinct
        .includes(:team_memberships => [:member, :role])
      @projects = @projects.page(params[:page]) if @projects.count > 500
    end
  end
end
