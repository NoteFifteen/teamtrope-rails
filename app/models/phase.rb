class Phase < ActiveRecord::Base
	has_many :tasks
	
	def tasks_in_workflows(workflows)
		self.tasks.where(workflow_id: workflows).order(:horizontal_order)
	end
	
end
