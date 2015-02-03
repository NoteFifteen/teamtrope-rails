class Task < ActiveRecord::Base
  belongs_to :workflow
  belongs_to :phase
  
  belongs_to :next_task, class_name: "Task", foreign_key: :next_id
  belongs_to :rejected_task, class_name: "Task" #, foreign_key: :rejected_task_id
  
  has_many :task_prerequisite_fields, foreign_key: :task_id
  
  has_many :task_performers, foreign_key: :task_id, dependent: :destroy
  has_many :performers,      through: :task_performers,   source: :role
  
  has_many :unlocked_tasks, class_name: "UnlockedTask", foreign_key: "task_id", dependent: :destroy
  has_many :unlocked, through: :unlocked_tasks, source: :unlocked_task
    
  # if we have a partial to save make sure to strip off the leading '_' and the extensions
  before_save { self.partial = partial.gsub(/^_/,"").gsub(/\.html\.erb/,"") unless partial.nil? }
  
end
