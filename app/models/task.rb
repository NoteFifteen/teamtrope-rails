class Task < ActiveRecord::Base
  belongs_to :workflow
  belongs_to :phase

  belongs_to :next_task, class_name: 'Task', foreign_key: :next_id
  belongs_to :rejected_task, class_name: 'Task' #, foreign_key: :rejected_task_id

  has_many :task_prerequisite_fields, foreign_key: :task_id

  has_many :task_performers, foreign_key: :task_id, dependent: :destroy
  has_many :performers,      through: :task_performers,   source: :role

  has_many :unlocked_tasks, class_name: 'UnlockedTask', foreign_key: 'task_id', dependent: :destroy
  has_many :unlocked, through: :unlocked_tasks, source: :unlocked_task

  has_many :task_dependencies, class_name: 'TaskDependency', foreign_key: 'main_task_id', dependent: :destroy
  has_many :dependent_tasks, through: :task_dependencies, source: :dependent_task

  # if we have a partial to save make sure to strip off the leading '_' and the extensions
  before_save { self.partial = partial.gsub(/^_/,"").gsub(/\.html\.erb/,"") unless partial.nil? }

  # return the override if we have one otherwise return the name
  def display_name
    override_name || name
  end

  # Look for a method that can determine whether or not we're visible.  The default is true.
  def visible?(project, current_user)
    call_name = self.name.downcase.gsub(/ /, '_') + '_is_visible?'
    if respond_to? call_name.to_sym
      send(call_name.to_sym, project, current_user)
    else
      true
    end
  end

  # Method to determine if a tab should be visible for the project
  # We want the rights_back_request_accounts to be defined as an env variable
  # or in application.yml.  It is a space delimited list of login names.
  def rights_back_request_is_visible?(project, current_user)
    if ! Figaro.env.rights_back_request_accounts
      return false
    end

    if(project.enable_rights_request)
      allowed_user_list = Figaro.env.rights_back_request_accounts
      allower_users = allowed_user_list.split(' ')

      if(allower_users.include?(current_user.nickname))
        return true
      end
    end

    false
  end

end
