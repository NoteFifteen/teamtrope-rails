class ProjectTypeWorkflow < ActiveRecord::Base
  belongs_to :workflow
  belongs_to :projectType
end
