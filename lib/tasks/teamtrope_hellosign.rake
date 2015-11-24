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


  desc 'Retries failed jobs if they meet the requirements'
  task retry_failed_jobs: :environment do
    total_failures = Resque::Failure.count

    # this guy is very important we are removing items for a list as we process
    # one by one so the index is offset by n where n is the number of jobs removed
    # from the queue previously
    offset = 0

    # getting the entire list of failed jobs.
    failed_jobs = Resque::Failure.all(0, total_failures)

    # loop through all jobs one by one
    failed_jobs.each_with_index do | failed_job, index |
      error = failed_job['error']

      # resque-status plugs in the resque_id to the payload so we can
      # be safe accessing [0] and [1] for the resque_id and our args that we
      # pass to the job.
      resque_id = team_membership_id = failed_job['payload']['args'][0]
      team_membership_id = failed_job['payload']['args'][1]['team_membership_id']

      # fun ruby trick. All statements return an object so setting expected_project_id
      # to the case statement will return whatever it matches works with if statements too
      expected_project_id = case error
      when /^No legal name.*?, project id: ([0-9]+)$/
        $1
      when /^The project layout doesn't.*?project id: ([0-9]+)$/
        $1
      end

      # looking up the team membership
      team_membership = TeamMembership.find_by_id(team_membership_id)

      # we can't retry this job if the team_membership has already been deleted.
      if team_membership.nil?
        puts "skipping: #{resque_id},#{team_membership_id},#{expected_project_id},team_membership not found,#{error}"
        next
      end

      # NOTE: after we implement author agreements, etc we would either most likely allow
      # the project to be blank or update this rake task to only look at the cta queue
      if team_membership.project.nil?
        puts "skipping: #{resque_id},#{team_membership_id},#{expected_project_id},missing a project,#{error}"
      end

      actual_project_id = team_membership.project.id

      # there might be something wrong please investigate
      if expected_project_id.to_i != actual_project_id
        "skipping: #{resque_id},#{team_membership_id},#{expected_project_id},expected: #{expected_project_id} doesn't match actual: #{actual_project_id},#{error}"
        next
      end

      # only retry the job if the project layout is not nil and there is a legal_name
      unless team_membership.project.layout.nil? || team_membership.project.layout.legal_name.nil?
        puts "will retry #{index} : #{resque_id}"
        Resque::Failure.requeue(index - offset)
        Resque::Failure.remove(index - offset)

        # updating the offset
        offset = offset + 1
      else
        # determining why we skipped and setting the appropriate message with  our
        # handy ruby short cut
        nil_type = if team_membership.project.layout.nil?
          'layout nil'
        elsif team_membership.project.layout.legal_name.nil?
          'missing legal_name'
        end
        puts "skipping: #{resque_id},#{team_membership_id},#{expected_project_id},#{nil_type},#{error}"
      end
    end

  end
end
