class SigningRequestJob
  include Resque::Plugins::Status

  @queue = :signing_request
  def perform

    current_step = 0
    total_steps = 3
    at(current_step+=1, total_steps, "Starting...")

    team_membership_id = options["team_membership_id"]

    raise "No team_membership_id provided!" if team_membership_id.nil?

    team_membership = TeamMembership.find team_membership_id

    raise "No team_membership found for #{team_membership_id}" if team_membership.nil?

    at(current_step+=1, total_steps, "Sending Request...")
    # sending the creative team agreement!

    sleep 5.0
    HellosignDocument.send_creative_team_agreement team_membership

    at(current_step+=1, total_steps, "Finished.")
  end
end
