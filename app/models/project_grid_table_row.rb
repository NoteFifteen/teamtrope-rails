class ProjectGridTableRow < ActiveRecord::Base
  belongs_to :project
  belongs_to :production_task, class_name: "Task"
  belongs_to :marketing_task, class_name: "Task"
  belongs_to :design_task, class_name: "Task"

  scope :published_books, -> {
    joins(:project)
    .includes(project: [:control_number, :publication_fact_sheet, :layout, :published_file])
    .where("production_task_name = ?", "Production Complete")
  }

  def set_task_display_name(workflow, name)
    puts self["#{workflow}_task_id"]
    task = Task.find self["#{workflow}_task_id"]
    self["#{workflow}_task_display_name"] = name
  end
end
