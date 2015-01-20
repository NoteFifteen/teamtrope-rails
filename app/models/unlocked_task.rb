class UnlockedTask < ActiveRecord::Base
  belongs_to :task
  belongs_to :unlocked_task, class_name: "Task", foreign_key: :unlocked_task_id
end
