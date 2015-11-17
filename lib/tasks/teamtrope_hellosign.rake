namespace :teamtrope do
  desc "Provided a comma delimited list of projects, enqueue all CTA signing requests. \n rake teamtrope:send_ctas PROJECT_IDS=1,2,4 ENQUEUE=1"
  task send_ctas: :environment do
    raise "You must provide a comma delimited list of project ids." if ENV["PROJECT_IDS"].nil?

    should_enqueue = ENV["ENQUEUE"] ? true : false

    if ! should_enqueue
      puts "WARNING the environemnt variable ENQUEUE has not been set."
      puts "Please set ENQUEUE=1 if you when you are ready to enqueue the signing requests."
    end

    project_ids = ENV["PROJECT_IDS"].split(",")


    project_ids.each do | project_id |
      project = Project.find project_id
      next if project.nil?

      project.team_memberships.each do | membership |
        puts "Enqueueing signing request for team_membership_id: #{membership.id} for project_id: #{membership.project_id} for member: #{membership.member.email} role: #{membership.role.name}"
        if should_enqueue && membership.role.needs_agreement?
          SigningRequestJob.create team_membership_id: membership.id
        end
      end

    end

  end

  desc "Displays a list of projects that cause failures do to either a missing layout or legal_name. \n rake teamtrope:projects_with_holes REPORT=[csv|urls]"
  task projects_with_holes: :environment do

    report_type = ENV['REPORT']
    report_type ||= 'csv'

    projects_with_holes_in_data = {}

    total_failed = Resque::Failure.count
    failed_jobs = Resque::Failure.all(0, total_failed)

    failed_jobs.each do | failed_job |
      error = failed_job['error']
      resque_id = team_membership_id = failed_job['payload']['args'][0]
      team_membership_id = failed_job['payload']['args'][1]['team_membership_id']
      project_id = case error
      when /^No legal name.*?, project id: ([0-9]+)$/
        $1
      when /^The project layout doesn't.*?project id: ([0-9]+)$/
        $1
      end

      project = Project.find(project_id)

      # no need to reinsert the same project...what's faster putting the same data
      # into the same spot or an if statement? does it really matter?
      projects_with_holes_in_data[project_id] = project unless projects_with_holes_in_data.has_key? project_id
    end

    case report_type
    when 'csv'
      csv_report projects_with_holes_in_data
    when 'urls'
      url_report projects_with_holes_in_data
    else
      # default to csv if the requested report is one we don't support
      csv_report projects_with_holes_in_data
    end
  end

  # prints a csv report of the projects (project_id, project_url)
  def csv_report(projects)
    puts "project_id,project_url"
    iterate_projects_with_block(projects) { | key, project | puts "#{key},#{url_for_project(project)}" }
  end

  # prints a list of urls for the projects (project_url)
  def url_report(projects)
    iterate_projects_with_block(projects) { | key, project | puts "#{url_for_project(project)}" }
  end

  # gets the url for a project based on the Rails Environment
  # for now development and test are the same, if we split development and test
  # we will want to move test to its own when.
  def url_for_project(project)
    case Rails.env
    when 'development', 'test'
      "https://teamtrope-staging.herokuapp.com/#{project.slug}"
    when 'production'
      "https://projects.teamtrope.com/#{project.slug}"
    end
  end

  # iterates through a list of projects executing a block if provided.
  def iterate_projects_with_block(projects)
    projects.each do | key, project |
      yield(key, project) if block_given?
    end
  end

end
