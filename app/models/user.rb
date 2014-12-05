class User < ActiveRecord::Base

	has_many :posts, foreign_key: "author_id", dependent: :destroy
	has_many :comments, dependent: :destroy
	
	has_attached_file :avatar,
		:styles => { :large => "600x600>", :medium => "300x300>", :thumb => "100x100>"},
		:convert_options => { :large => "-quality 100", :medium => '-quality 100', :thumb => '-quality 100' },
		:default_url => "/images/:style/missing.gif",
		:processors => [:cropper] 
		
	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

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

	def cropping?
		!crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
	end
	
	def avatar_geometry(style = :original)
		@geometry ||= {}
		@geometry[style] ||= Paperclip::Geometry.from_file(avatar.path(style))
	end

  private
    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

end
