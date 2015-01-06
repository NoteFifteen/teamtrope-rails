class Workflow < ActiveRecord::Base
	has_many :workflow_steps
	has_many :steps, through: :workflow_steps, source: :task

	belongs_to :workflow_step, foreign_key: :root_step_id
		
	def root
		#WorkflowStep.find(self.root_task_id)
		self.workflow_step
	end
end
