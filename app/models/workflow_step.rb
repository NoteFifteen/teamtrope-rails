class WorkflowStep < ActiveRecord::Base
  belongs_to :workflow
  belongs_to :task
  
  has_one :root_step, foreign_key: :root_step_id
  
  def next_step
  	WorkflowStep.where(id: self.next_step_id).first
  end
  
  def rejected_step
  	WorkflowStep.where(id: self.rejected_step_id).first
  end
  
end
