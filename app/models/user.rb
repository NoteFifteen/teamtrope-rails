class User < ActiveRecord::Base

  # devise configuration
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:wordpress_hosted]

  # will_paginate pagination configuration
  self.per_page = 10

  has_one :profile, dependent: :destroy

  has_many :team_memberships, foreign_key: :member_id, dependent: :destroy
  has_many :audit_team_membership_removals, foreign_key: :member_id
  has_many :projects, through: :team_memberships, source: :project, join_table: :roles

  before_save { self.email = email.downcase }
  #before_create :create_remember_token
  #validates :name, presence: true, length: { maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
              format: {with: VALID_EMAIL_REGEX},
              uniqueness: { case_sensitive: false }
  #has_secure_password

  # There's a conflict with the has_secure_password
  # validates :password, length: { minimum: 8 }
  # validates :password_confirmation, presence: true

  default_scope -> { order('LOWER(name) ASC') }

  scope :with_role, ->(role) { where("roles_mask & #{2**ROLES.index(role.to_s)} > 0") }
  scope :active_users, -> { where(active: true) }
  scope :inactive_users, -> { where(active: false) }


  ROLES = %w[booktrope_staff moderator author book_manager cover_designer editor project_manager proof_reader volunteer observer illustrator]

  def inactive?
      !active
  end

  def profile_page
    "https://teamtrope.com/members/#{nickname}"
  end

  def self.find_for_wordpress_oauth2(oauth, signed_in_user=nil)


    #if the user was already signed in / but they navigated through the authorization with wordpress
    if signed_in_user
      #update / synch any information you want from the authentication service.
      if signed_in_user.email.nil? or signed_in_user.email.eql?('')
        signed_in_user.update_attributes(email: oauth['info']['email'])
      end

      return signed_in_user
    else
      #find user by id and provider.
      user = User.find_by_provider_and_uid(oauth['provider'], oauth['uid'])

      #if user isn't in our database yet, create it!
      if user.nil?

        user = User.find_by_email(oauth['info']['email'])

        # user already exists so update it with meta from wp.
        if user
          user.update_attributes(uid: oauth['uid'], provider: oauth['provider'],
                  nickname: oauth['extra']['raw_info']['user_login'],
                  website: oauth['info']['urls']['Website'], display_name: oauth['extra']['raw_info']['display_name'])

          # Attempt to update Avatar if one has not been configured here
          if(! user.profile.avatar.present?)
            user.profile.import_avatar_from_url(oauth['extra']['raw_info']['avatar_url'])
          end
        else
          user = User.create!(email: oauth['info']['email'], uid: oauth['uid'], provider: oauth['provider'],
                              nickname: oauth['extra']['raw_info']['user_login'], website: oauth['info']['urls']['Website'],
                              display_name: oauth['extra']['raw_info']['display_name'])
          user.create_profile!
          # Attempt to import avatar
          user.profile.import_avatar_from_url(oauth['extra']['raw_info']['avatar_url'])
        end
      end

      # Attempt to update Avatar if one has not been configured here
      if(! user.profile.avatar.present?)
        user.profile.import_avatar_from_url(oauth['extra']['raw_info']['avatar_url'])
      end
      user
    end
  end

  #we don't require a password for our wordpress authenticated users.
  def password_required?
    false
  end

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def role?(role)
    roles.include? role.to_s
  end


end
