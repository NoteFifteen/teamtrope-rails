class Project < ActiveRecord::Base

	include PublicActivity::Model

	belongs_to :project_type
	
	has_many :team_memberships
	has_many :members, through: :team_memberships, source: :member
	
	has_many :roles, through: :team_memberships, source: :role
	
	has_many :book_genres, foreign_key: :project_id, dependent: :destroy
	has_many :genres, through: :book_genres, source: :genre
	
	has_many :current_tasks

  has_one :control_number, dependent: :destroy
  
  has_attached_file :manuscript_original
  has_attached_file :manuscript_edited
  has_attached_file :layout_upload
  
  ContentType_Document = ['application/msword', 
  			'application/vnd.openxmlformats-officedocument.wordprocessingml.document']
  
  validates_attachment :manuscript_original,
  	:content_type => { content_type: ContentType_Document }, 
  	:size => { :in => 0..120.megabytes }
  	
  validates_attachment :manuscript_edited,
  	:content_type => { content_type: ContentType_Document },
  	:size => { :in => 0..120.megabytes }
  	
	accepts_nested_attributes_for :team_memberships, reject_if: :all_blank, allow_destroy: true    	

  # Available options for the layout style form -> layout style. Stored in 'layout_style_choice'
  LayoutStyleFonts = [['Cambria'], ['Covington'], ['Headline Two Exp'],['Letter Gothic'],['Lobster'],['Lucida Fax'],['M V Boli']]

  # Available options for the layout style -> Left Side Page Header Display - Name.  Stored in page_header_display_name
  PageHeaderDisplayNameChoices = [['Full Name'], ['Last Name Only']]

  def team_complete?
		required_roles = project_type.required_roles.ids
		team_members = team_memberships.map { |member| member.role_id }
		
		required_roles.all? {| required_role | team_members.include? required_role }
	end

  def available_roles
    required_roles = project_type.required_roles.ids
    team_members = team_memberships.map { |member| member.role_id }
    available = required_roles - team_members

    project_type.roles.where(id: available)
  end

	def is_team_member?(user)
		members.ids.include?(user.id)
	end
	
	def is_my_editor?(user)
		team_memberships.where(member_id: user.id, role_id: Role.where(name: "Editor")).count > 0
	end
	
	def team_roles(user)
		team_memberships.where(member_id: user.id).map { | membership | membership.role }
	end
	
	def team_members_with_roles
		team_memberships.select("roles.name").joins(:role).includes(:role, 
		:member).order("roles.name").group_by(&:member_id).map do | key, memberships |
				{ :member => memberships.first.member, :roles => memberships.map {|membership| 
				membership.role.name }.join(", ")  
				}
		end	
	end

  def team_allocations
    team = []
    project_type.required_roles.each do |rr|

      role = self.send(rr.role.normalized_name.pluralize).first
      member_name = (role.nil?) ? '' : role.member.name
      member_percentage = (role.nil?) ? 0 : self.send(rr.role.normalized_name.pluralize).first.percentage

      team << { :role_name => rr.role.name,
                :member_name => member_name,
                :suggested_percentage => rr.suggested_percent,
                :allocated_percentage => member_percentage
             }
    end
    return team
  end

	def self.provide_methods_for(role)
		Project.class_eval %Q{	
			def has_#{role.downcase.gsub(/ /, "_")}?
				team_memberships.where(role_id: Role.where(name: "#{role}")).count > 0
			end
		}
		Project.class_eval %Q{
			def #{role.downcase.gsub(/ /, "_").pluralize}
				team_memberships.where(role_id: Role.where(name: "#{role}"))
			end
		}
	end
	
	Role.all.map{ |role| role.name  }.each do | role |
		provide_methods_for(role)
	end
	
	
end
