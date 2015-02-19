class Role < ActiveRecord::Base
	has_many :team_memberships
	has_many :users, through: :team_memberships, source: :member
	
	has_many :task_performers, foreign_key: :role_id, dependent: :destroy
	has_many :tasks,     through: :task_performers, source: :task	
	
	default_scope -> { order("name asc") }
end