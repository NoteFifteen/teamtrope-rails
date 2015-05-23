class TaskDependency < ActiveRecord::Base
  belongs_to :main_task, class_name: "Task", foreign_key: :main_task_id
  belongs_to :dependent_task, class_name: "Task", foreign_key: :dependent_task_id
end
