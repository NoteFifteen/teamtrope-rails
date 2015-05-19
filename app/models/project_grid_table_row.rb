class ProjectGridTableRow < ActiveRecord::Base
  belongs_to :project
  belongs_to :production_task, class_name: "Task"
  belongs_to :marketing_task, class_name: "Task"
  belongs_to :design_task, class_name: "Task"
end
