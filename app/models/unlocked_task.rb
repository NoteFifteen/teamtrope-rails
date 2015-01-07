class UnlockedTask < ActiveRecord::Base
  belongs_to :workflow_step
  belongs_to :task, foreign_key: :unlocked_task_id
end
