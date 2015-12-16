class AddRightsRequestTab < ActiveRecord::Migration
  def up
    team_change = Task.find_by_name('Team Change')
    return if team_change.nil?

    #creating the new tasks
    rights_back_request = Task.new
    rights_back_request.name = 'Rights Back Request'
    rights_back_request.tab_text = 'Rights Back Request'
    rights_back_request.partial = 'rights_back_request'
    rights_back_request.icon = 'icon-exchange'
    rights_back_request.team_only = false
    rights_back_request.save

    # update unlocked tasks -- Tying to Production because we have to use something
    # to unlock these tasks, even though they're not really tied to any particular
    # workflow.
    production_workflow = Workflow.find_by_name('Production')
    production_workflow.tasks.each do | task |
      task.unlocked_tasks.create(unlocked_task: rights_back_request)
    end

    # Creating the tab  and add the view task tab after 'Team Change'
    team_change_tab = Tab.find_by_task_id(team_change.id)
    phase = team_change_tab.phase
    order = team_change_tab.order

    rights_back_request_tab = Tab.new
    rights_back_request_tab.task = rights_back_request
    rights_back_request_tab.phase = phase
    rights_back_request_tab.order = order + 1
    rights_back_request_tab.save

  end

  # remove the tasks
  def down
    team_change = Task.find_by_name('Team Change')
    rights_back_request = Task.find_by_name('Rights Back Request')

    return if team_change.nil? || rights_back_request.nil?

    # No tabs after, so safe to remove
    rights_back_request_tab = Tab.find_by_task_id(rights_back_request)

    UnlockedTask.where(unlocked_task: rights_back_request).destroy_all

    rights_back_request.destroy
    rights_back_request_tab.destroy
  end
end
