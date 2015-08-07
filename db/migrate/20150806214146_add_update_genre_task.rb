class AddUpdateGenreTask < ActiveRecord::Migration
  def up
    # Find the Phase
    phase = Phase.find_by_name('Marketing Prep')

    # Now locate the last tab for the phase to get the task
    last_tab = Tab.where(:phase_id => phase.id).last

    # Add the task
    update_task = Task.new
    update_task.name = 'Update Genre'
    update_task.tab_text = 'Update Genre'
    update_task.partial = 'update_genre'
    update_task.icon = 'icon-magic'
    update_task.team_only = true
    update_task.save

    # Add the tab for it
    new_tab_item = Tab.new
    new_tab_item.phase_id = phase.id
    new_tab_item.order = last_tab.order + 1
    new_tab_item.task_id = update_task.id
    new_tab_item.save

    # Add to unlocked tasks for every task for this phase
    Tab.where(:phase_id => phase.id).each do |t|
      unlock = UnlockedTask.new
      unlock.task_id = t.task_id
      unlock.unlocked_task = update_task
      unlock.save
    end
  end

  def down
    # Locate the task
    task = Task.find_by_name('Update Genre')

    return if task.nil?

    # Destroy the tab
    Tab.find_by_task_id(task.id).destroy

    # Remove the Unlocked Tasks
    UnlockedTask.where(:unlocked_task_id => task.id).destroy_all

    # Remove the Task
    task.destroy
  end

end
