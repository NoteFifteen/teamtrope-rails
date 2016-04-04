class AddKdpSelectStatusTab < ActiveRecord::Migration

  def up

    # look up the update task
    kdp_update_task = Task.find_by_name "KDP Update"

    # punt if we don't find one
    return if kdp_update_task.nil?

    # create the new task
    kdp_status_task = Task.create(
      name: 'KDP Select Status',
      tab_text: 'KDP Select Status',
      icon: 'icon-bookmark',
      team_only: true,
      partial: 'kdp_select_enrollment_status'
    )

    # copy the unlocked tasks from the KDP Update Task
    UnlockedTask.where(unlocked_task_id: kdp_update_task).each do | unlocked_task |
      unlocked_task.task.unlocked_tasks.create(unlocked_task_id: kdp_status_task.id)
    end

    # copy the performers from the KDP Update Task
    kdp_status_task.performers = kdp_update_task.performers
    kdp_status_task.save

    # look up the update task's tab
    kdp_update_tab = Tab.find_by_task_id kdp_update_task.id

    return if kdp_update_tab.nil?

    # insert the new tab into the project view.
    kdp_status_tab = kdp_update_tab.make_new_tab_after(kdp_status_task)

  end

  def down
    kdp_status_task = Task.find_by_name "KDP Select Status"
    kdp_status_tab = Tab.find_by_task_id kdp_status_task.id

    kdp_update_task = Task.find_by_name "KDP Update"
    kdp_update_tab = Tab.find_by_task_id kdp_update_task.id

    kdp_status_task.destroy
    kdp_status_tab.destroy

    kdp_update_tab.move_subsequent_tabs_left

  end

end
