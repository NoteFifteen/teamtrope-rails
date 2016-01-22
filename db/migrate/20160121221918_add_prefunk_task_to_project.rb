class AddPrefunkTaskToProject < ActiveRecord::Migration
  def up

    # find the marketing phase
    phase = Phase.find_by_name("Marketing")

    return if phase.nil?

    # locate the last tab which will have the last task
    last_tab = Tab.where(phase_id: phase.id).last

    return if last_tab.nil?

    prefunk_enrollment_task = Task.create(
      name: "Prefunk Enrollment",
      icon: "icon-file-alt",
      tab_text: "Prefunk Enrollment",
      team_only: true,
      partial: "prefunk_enrollment"
    )

    # create the tab
    prefunk_tab = phase.tabs.create(
      order: last_tab.order + 1,
      task_id: prefunk_enrollment_task.id,
    )

    # copy unlocked tasks from previous last marketing tab
    UnlockedTask.where(unlocked_task: last_tab.task).each do | unlocked_task |
      unlocked_task.task.unlocked_tasks.create(unlocked_task: prefunk_enrollment_task)
    end


  end

  def down

    task = Task.find_by_name("Prefunk Enrollment")

    return if task.nil?

    # Destroy the tab
    Tab.find_by_task_id(task.id).destroy

    # remove the unlocked tasks
    UnlockedTask.where(unlocked_task: task).destroy_all

    # destroy the task
    task.destroy

  end
end
