class Task < ActiveRecord::Base
  belongs_to :workflow
  belongs_to :phase
  
  has_many :unlocked_tasks
  
  has_many :task_prerequisite_fields, foreign_key: :task_id
  
  has_many :task_performers, foreign_key: :task_id, dependent: :destroy
  has_many :performers,      through: :task_performers,   source: :role
  
  validates :workflow_id, presence: true
  
  def next_task
  	Task.where(id: self.next_id).first
  end
  
  def rejected_task
  	Task.where(id: self.rejected_task_id).first
  end
  
end
