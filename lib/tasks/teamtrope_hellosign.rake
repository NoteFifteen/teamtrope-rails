namespace :teamtrope do
  desc "Provided a comma delimited list of projects, enqueue all CTA signing requests. \n rake teamtrope:send_ctas PROJECT_IDS=1,2,4 ENQUEUE=1"
  task send_ctas: :environment do
    raise "You must provide a comma delimited list of project ids." if ENV["PROJECT_IDS"].nil?

    project_ids = ENV["PROJECT_IDS"].split(",")
    should_enqueue = ENV["ENQUEUE"] ? true : false

    project_ids.each do | project_id |
      project = Project.find project_id
      next if project.nil?

      project.team_memberships.each do | membership |
        puts "Enqueued signing request for team_membership_id: #{membership.id} for project_id: #{membership.project_id} for member: #{membership.member.email} role: #{membership.role.name}"
        if should_enqueue && membership.role.needs_agreement?
          SigningRequestJob.create team_membership_id: membership.id
        end
      end

    end

  end
end
