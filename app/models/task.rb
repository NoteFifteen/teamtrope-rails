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

  has_many :task_dependencies, class_name: "TaskDependency", foreign_key: "main_task_id", dependent: :destroy
  has_many :dependent_tasks, through: :task_dependencies, source: :dependent_task

  # if we have a partial to save make sure to strip off the leading '_' and the extensions
  before_save { self.partial = partial.gsub(/^_/,"").gsub(/\.html\.erb/,"") unless partial.nil? }

  # before destroying, destroy associated tab, and remove this task from unlocked tasks lists
  # (should only ever come up in migrations!)
  before_destroy do |task|
    tab = Tab.find_by_task_id(task.id)
    tab.destroy if tab
    UnlockedTask.where(unlocked_task_id: task.id).destroy_all
  end
end
