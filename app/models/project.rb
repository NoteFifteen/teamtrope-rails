class Project < ActiveRecord::Base
	belongs_to :project_type
	
	has_many :team_memberships
	has_many :members, through: :team_memberships, source: :member
	
	has_many :roles, through: :team_memberships, source: :role
	
	has_many :book_genres, foreign_key: :project_id, dependent: :destroy
	has_many :genres, through: :book_genres, source: :genre
	
	has_many :current_tasks
	
	def team_complete?
		required_roles = project_type.required_roles.ids
		team_members = team_memberships.map { |member| member.role_id   }
		
		required_roles.all? {| required_role | team_members.include? required_role }
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
