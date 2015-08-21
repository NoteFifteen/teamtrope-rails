class TeamMembership < ActiveRecord::Base
  belongs_to :project, inverse_of: :team_memberships
  belongs_to :role
  belongs_to :member, foreign_key: :member_id, class_name: :User

  validates_presence_of :project
  validates :role_id, presence: true
  validates :member_id, presence: true
  validates :percentage, presence: true

  has_one :hellosign_document

  # callbacks - when a team_membership has been created or the percentage has been
  # modified create and send a signing request via hellsign
  after_create :send_creative_team_agreement, unless: :skip_callbacks
  after_update :send_agreement_when_percentage_updated, unless: :skip_callbacks

  #
  RemovalReasons = [
      ['refuses_teamtrope', 'Refuses to work in Teamtrope'],
      ['workload', 'Their workload does not allow for continuation on this particular team, no hardship'],
      ['quality_of_work', 'Quality of work is not sufficient'],
      ['personality', 'Personality Differences'],
      ['leaving','Leaving Booktrope due to outside circumstances'],
      ['other','<input id="team_removal_reason_other_input" name="team_removal_reason_other_input" type="text" value="Other">'.html_safe]
  ]

  # The Removal Reasons in an array of arrays of reasons in ['key' => 'val'] format.  We have a key, we need the value.
  def get_removal_reason(key)
    reason = ''
    RemovalReasons.each do |reason_key, reason_val|
      if reason_key == key
        reason = reason_val
        break
      end
    end

    reason
  end

  private

  #only send an amended agreement if the percentage has changed.
  def send_agreement_when_percentage_updated
    send_creative_team_agreement if percentage_changed?
  end

  def send_creative_team_agreement
    HellosignDocument.send_creative_team_agreement(self) if self.role.needs_agreement?
  end

end

