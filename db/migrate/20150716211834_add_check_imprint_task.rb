class AddCheckImprintTask < ActiveRecord::Migration

  # add and insert Check Imprint Task after Approve Layout
  def up
    approve_layout = Task.find_by_name("Approve Layout")

    return if approve_layout.nil?

    new_task = Task.new
    new_task.name = 'Check Imprint'
    new_task.tab_text = 'Check Imprint'
    new_task.partial = 'check_imprint'
    new_task.icon = 'icon-cogs'
    new_task.next_id = approve_layout.next_task.id
    new_task.team_only = true
    new_task.workflow = approve_layout.workflow
    new_task.save

    # copying the unlocked tasks from Approve Layout except for Approve Layout.
    approve_layout.unlocked_tasks.each do | task |
      new_task.unlocked_tasks.create!(unlocked_task: task.unlocked_task) unless task.unlocked_task.name == "Approve Layout"
    end

    # set the next task to the newly created Check Imprint task.
    approve_layout.next_task = new_task
    approve_layout.save

    # add the new task after Approve layout
    approve_layout_tab = Tab.find_by_task_id(approve_layout.id)
    new_tab = Tab.new
    new_tab.task = new_task
    new_tab.phase = approve_layout_tab.phase
    new_tab.order = approve_layout_tab.order + 1
    new_tab.save

    # adjust all remaining tabs
    remaining_tabs = new_tab.phase.tabs.joins(:task)
      .where("tabs.order >= ? and tasks.name != ? ", new_tab.order, new_task.name)

    remaining_tabs.each do | tab |
      tab.order = tab.order + 1
      tab.save
    end


  end

  # Remove Check Imprint Task
  def down
    approve_layout = Task.find_by_name("Approve Layout")
    check_imprint = Task.find_by_name("Check Imprint")

    return if approve_layout.nil? || check_imprint.nil?

    # set approve_layout's next pointer to check_imprint's next
    approve_layout.next_id = check_imprint.next_id
    approve_layout.save

    # retrieve the check_imprint's tab
    check_imprint_tab = Tab.find_by_task_id(check_imprint)

    remaining_tabs = check_imprint_tab.phase.tabs
      .joins(:task)
      .where("tabs.order > ?", check_imprint_tab.order)

    # move all remaining tabs over by 1
    remaining_tabs.each do | remaining_tab |
      remaining_tab.order = remaining_tab.order - 1
      remaining_tab.save
    end

    # update current tasks to point to the approve layout task
    CurrentTask.where(task_id: check_imprint.id).each do | ct |
      ct.task_id = approve_layout.id
      ct.save
    end

    # destroy the unnecessary data.
    check_imprint.destroy
    check_imprint_tab.destroy
  end
end
