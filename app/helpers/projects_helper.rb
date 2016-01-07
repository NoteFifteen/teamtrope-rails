module ProjectsHelper

  # Handle the various methods for showing 'The Grid' including various filters
  def get_projects_for_index(filters)
    if filters.has_key?(:show)
      get_by_show_filter(filters[:show])
    else
      if filters.has_key?(:author) && ! filters[:author].nil?
        get_by_author_nickname(filters[:author])
      end
    end

    # Safe fall-back if we can't find anything
    if @projects.nil?
      get_my_projects
    end
  end

  # Search by a special 'show' filter which includes workflow and task filters
  def get_by_show_filter(filter_by)
    filters = Constants::ProjectsIndexFilters
    filters = filters.merge(Constants::AdminProjectsIndexFilters) if current_user.role? :booktrope_staff
    @grid_title = "The Grid"

    unless filter_by.nil? || !filters.has_key?(filter_by.to_sym)
      if filter_by.to_sym == :all
        @projects = ProjectGridTableRow.includes(project: [:cover_template]).all
      elsif filter_by.to_sym == :my_books
        get_my_projects
      elsif filter_by.to_sym == :not_published
        get_unpublished_books
      else
        @grid_title =  filters[filter_by.to_sym][:label]
        @grid_title =  filters[filter_by.to_sym][:task_name] if @grid_title.empty?
        pgtr_meta_hash = filters[filter_by.to_sym]
        @projects = ProjectGridTableRow.includes(project: [:cover_template]).where("#{pgtr_meta_hash[:workflow_name]}_task_name = ?", pgtr_meta_hash[:task_name])
      end
    end
  end

  # gets the list of unpublished books to display in the grid
  def get_unpublished_books
    @grid_title = "Not Published"

    # get task 'Production Complete' which is a published book
    published_task = Task.find_by_name("Production Complete")
    workflow_task = published_task.workflow.root

    # get all tasks in the workflow that occur before production compelete.
    not_published_tasks = []
    while next_task = workflow_task.next_task

      # we don't want to include published_task
      break if next_task.id == published_task.id

      not_published_tasks.push next_task.name
      workflow_task = next_task
    end
    @projects = ProjectGridTableRow.includes(project: [:cover_template]).where("production_task_name in (?)", not_published_tasks)
  end

  # Search using the author's Nickname (@name in OldTrope)
  def get_by_author_nickname(author_name)
    user = User.where('LOWER(nickname) = LOWER(?)', author_name).first
    if(user.nil?)
      get_my_projects
    else
      @grid_title = ("Books by #{user.name} (@#{author_name})").html_safe

      #@todo May be worth refactoring in the future, though difficult due to the dependent relationships
      @projects = ProjectGridTableRow.find_by_sql(["SELECT * FROM project_grid_table_rows
                                                    JOIN projects ON projects.id = project_grid_table_rows.project_id
                                                    JOIN team_memberships ON team_memberships.project_id = project_grid_table_rows.project_id
                                                    JOIN roles ON roles.id = team_memberships.role_id
                                                    JOIN users ON users.id = team_memberships.member_id
                                                    WHERE roles.name = 'Author' AND LOWER(users.nickname) = LOWER(?)", author_name])
    end
  end

  # Fall back method
  def get_my_projects
    @grid_title = "My Books"
    # We only want the book to show up once in the list so we use distinct.
    @projects = ProjectGridTableRow.where(project_id: current_user.projects.ids).distinct
  end

  def get_all_projects
    get_by_show_filter('all')
  end

end
