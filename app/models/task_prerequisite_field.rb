class TaskPrerequisiteField < ActiveRecord::Base
  belongs_to :workflow_step
end
