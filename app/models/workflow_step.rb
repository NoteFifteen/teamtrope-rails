class WorkflowStep < ActiveRecord::Base
  belongs_to :workflow
  belongs_to :task
  belongs_to :phase
  
  has_one :current_step
  
  has_many :task_prerequisite_fields, foreign_key: :workflow_step_id
  
  
  def next_step
  	WorkflowStep.where(id: self.next_step_id).first
  end
  
  def rejected_step
  	WorkflowStep.where(id: self.rejected_step_id).first
  end
  
end
