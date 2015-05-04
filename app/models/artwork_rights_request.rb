class ArtworkRightsRequest < ActiveRecord::Base
  belongs_to :project

  before_save { self.email = email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: { case_sensitive: false }

  validates :role_type, presence: true
  validates :full_name, presence: true, length: { maximum: 50}

  ArtistTypes = %w( Photographer Artist Model)

end
