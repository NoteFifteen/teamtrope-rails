class KdpSelectEnrollment < ActiveRecord::Base
  belongs_to :project
  belongs_to :member, foreign_key: :member_id, class_name: :User

  validates :project_id, presence: true
  validates :member_id, presence: true
  validates :enrollment_date, presence: true

end
