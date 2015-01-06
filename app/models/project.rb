class Project < ActiveRecord::Base
	belongs_to :project_type
	
	has_many :team_memberships
	has_many :members, through: :team_memberships, source: :member
	
end
