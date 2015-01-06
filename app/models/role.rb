class Role < ActiveRecord::Base
	has_many :team_memberships
	has_many :users, through: :team_memberships, source: :member
end
