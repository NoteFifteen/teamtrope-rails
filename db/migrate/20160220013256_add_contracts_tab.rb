class AddContractsTab < ActiveRecord::Migration
  def up

    # get the last tab on the row
    activity_task = Task.find_by_name 'Activity'

    return if activity_task.nil?

    # create our new task
    legal_docs_task = Task.create(
      name: 'Legal Docs',
      tab_text: 'Legal Docs',
      icon: 'icon-file',
      partial: 'contract_display_and_activity',
    )

    # set the unlocked tasks to be the same as activity_task
    UnlockedTask.includes(:task).where(unlocked_task: activity_task).each do | ut |
      ut.task.unlocked_tasks.create(unlocked_task: legal_docs_task)
    end

    # set the performers to all roles
    Role.find_each do | role |
      legal_docs_task.task_performers.create role: role
    end


    # add the task to the UI

    # look up activity_task's tab
    team_change_tab = Tab.find_by_task_id activity_task.id

    legal_docs_task = Tab.create(
      task: legal_docs_task,
      phase: team_change_tab.phase,
      order: team_change_tab.order + 1
    )

  end

  def down

    # look up the task and tab
    legal_docs_task = Task.find_by_name 'Legal Docs'
    legal_docs_task = Tab.find_by_task_id legal_docs_task.id

    return if legal_docs_task.nil? || legal_docs_task.nil?

    legal_docs_task.destroy
    legal_docs_task.destroy

  end
end
