class Workflow < ActiveRecord::Base
	has_many :tasks
	belongs_to :root, class_name: "Task", foreign_key: :root_task_id
end
