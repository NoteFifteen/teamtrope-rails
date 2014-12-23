class User < ActiveRecord::Base

	self.per_page = 10

	has_many :posts, foreign_key: "author_id", dependent: :destroy
	has_many :comments, dependent: :destroy
	has_one :profile, dependent: :destroy
	
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  validates :name, presence: true, length: { maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
							format: {with: VALID_EMAIL_REGEX},
							uniqueness: { case_sensitive: false }		
  has_secure_password
  validates :password, length: { minimum: 8 }
  validates :password_confirmation, presence: true
  
  default_scope -> { order('name ASC') }
	  
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
