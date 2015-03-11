class User < ActiveRecord::Base

	self.per_page = 10

	has_many :posts, foreign_key: "author_id", dependent: :destroy
	has_many :comments, dependent: :destroy
	has_one :profile, dependent: :destroy
	
	has_many :team_memberships, foreign_key: :member_id, dependent: :destroy
	has_many :projects, through: :team_memberships, source: :project, join_table: :roles
	
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  validates :name, presence: true, length: { maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
							format: {with: VALID_EMAIL_REGEX},
							uniqueness: { case_sensitive: false }		
  
  validates :password, length: { minimum: 8 }
  validates :password_confirmation, presence: true
  has_secure_password
  
  default_scope -> { order('name ASC') }
  
  scope :with_role, ->(role) { where("roles_mask & #{2**ROLES.index(role.to_s)} > 0") }
  
  ROLES = %w[booktrope_staff moderator author book_manager cover_designer editor project_manager proof_reader volunteer observer]
  
  def roles=(roles)
  	self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end
  
  def roles
  	ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end
  
  def role?(role)
  	roles.include? role.to_s
  end
	  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
  
  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

end
