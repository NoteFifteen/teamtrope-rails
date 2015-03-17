class TeamMembership < ActiveRecord::Base
  belongs_to :project
  belongs_to :role
  belongs_to :member, foreign_key: :member_id, class_name: :User

  validates :project_id, presence: true
  validates :role_id, presence: true
  validates :member_id, presence: true
  validates :percentage, presence: true

  #
  RemovalReasons = [
      ['refuses_teamtrope', 'Refuses to work in Teamtrope'],
      ['workload', 'Their workload does not allow for continuation on this particular team, no hardship'],
      ['quality_of_work', 'Quality of work is not sufficient'],
      ['personality', 'Personality Differences'],
      ['leaving','Leaving Booktrope due to outside circumstances'],
      ['other','<input id="team_removal_reason_other_input" name="team_removal_reason_other_input" type="text" value="Other">'.html_safe]
  ]

end
