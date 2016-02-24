class AddContractsTab < ActiveRecord::Migration
  def up

    # get the last tab on the row
    team_change_task = Task.find_by_name 'Team Change'

    return if team_change_task.nil?

    # create our new task
    contracts_task = Task.create(
      name: 'Contracts',
      tab_text: 'Contracts',
      icon: 'icon-file',
      partial: 'contract_display_and_activity',
    )

    # set the unlocked tasks to be the same as team_change_task
    UnlockedTask.includes(:task).where(unlocked_task: team_change_task).each do | ut |
      ut.task.unlocked_tasks.create(unlocked_task: contracts_task)
    end

    # set the performers to all roles
    Role.find_each do | role |
      contracts_task.task_performers.create role: role
    end


    # add the task to the UI

    # look up team_change_task's tab
    team_change_tab = Tab.find_by_task_id team_change_task.id

    contracts_tab = Tab.create(
      task: contracts_task,
      phase: team_change_tab.phase,
      order: team_change_tab.order + 1
    )

  end

  def down

    # look up the task and tab
    contracts_task = Task.find_by_name 'Contracts'
    contracts_tab = Tab.find_by_task_id contracts_task.id

    return if contracts_task.nil? || contracts_tab.nil?

    contracts_task.destroy
    contracts_tab.destroy

  end
end
