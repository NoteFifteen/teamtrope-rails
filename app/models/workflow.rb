class Workflow < ActiveRecord::Base

	has_many :tasks

	belongs_to :task, foreign_key: :root_task_id
		
	def root
		self.task
	end
end
