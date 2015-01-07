class CurrentStep < ActiveRecord::Base
  belongs_to :project
  belongs_to :workflow_step
end
