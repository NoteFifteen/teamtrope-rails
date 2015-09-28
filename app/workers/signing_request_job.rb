class SigningRequestJob
  include Resque::Plugins::Status

  @queue = :signing_request
  def perform

    at(0, 100, "Starting...")

    team_membership_id = options["team_membership_id"]

    raise "No team_membership_id provided!" if team_membership_id.nil?

    team_membership = TeamMembership.find team_membership_id

    raise "No team_membership found for #{team_membership_id}" if team_membership.nil?

    at(50, 100, "Sending Request...")
    # sending the creative team agreement!
    HellosignDocument.send_creative_team_agreement team_membership




    at(100, 100, "Finished.")
  end
end
