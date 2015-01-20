class ProjectTypeWorkflow < ActiveRecord::Base
  belongs_to :workflow
  belongs_to :project_type
  
end
