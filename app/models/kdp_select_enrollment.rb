class KdpSelectEnrollment < ActiveRecord::Base
  belongs_to :project
  belongs_to :member, foreign_key: :member_id, class_name: :User

  validates :project_id, presence: true
  validates :member_id, presence: true
  validates :enrollment_date, presence: true

  UpdateTypes = [
      ['countdown_deal', 'Countdown Deal'],
      ['free_book_promo', 'Free Book Promotion'],
      ['remove_from_kdp', 'Remove this book from KDP Select at the end of the current 90 day period'],
  ]

end
