class TeamMembership < ActiveRecord::Base
  belongs_to :project
  belongs_to :role
  belongs_to :member, foreign_key: :member_id, class_name: :User
end
