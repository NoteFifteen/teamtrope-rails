json.array!(@audit_team_membership_removals) do |audit_team_membership_removal|
  json.extract! audit_team_membership_removal, :id, :member_id, :notes, :notified_member, :percentage, :reason
  json.url audit_team_membership_removal_url(audit_team_membership_removal, format: :json)
end
