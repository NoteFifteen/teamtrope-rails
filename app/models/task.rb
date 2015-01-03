class Task < ActiveRecord::Base

	has_many :workflow_steps
	has_many :workflows, through: :workflow_steps

end
