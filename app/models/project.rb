class Project < ActiveRecord::Base
	belongs_to :project_type
	
	has_many :team_memberships
	has_many :members, through: :team_memberships, source: :member
	
	has_many :book_genres, foreign_key: :project_id, dependent: :destroy
	has_many :genres, through: :book_genres, source: :genre
	
	has_many :current_steps
	
end
