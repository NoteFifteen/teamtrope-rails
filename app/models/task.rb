class Task < ActiveRecord::Base
  belongs_to :workflow
  
  has_many :unlocked_tasks
  
  has_many :task_prerequisite_fields, foreign_key: :task_id
  
  def next_task
  	Task.where(id: self.next_id).first
  end
  
  def rejected_task
  	Task.where(id: self.rejected_task_id).first
  end
  
end
