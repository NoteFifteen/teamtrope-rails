def retext_tab(old_text, new_text)
  print "changing tab_text \"#{old_text}\" to \"#{new_text}\"\n"
  task = Task.find_by_tab_text(old_text)
  if task
    task.tab_text = new_text
    task.save
  else
    print "  not found!\n"
  end

end


class AddUpdatePsdTask < ActiveRecord::Migration

  @@renames = [{old_text: 'Cover Concept', new_text: 'Concept'},
               {old_text: 'Approve Cover', new_text: 'Approve'},
               {old_text: 'Request Image', new_text: 'Request Img'},
               {old_text: 'Add Image',     new_text: 'Add Img'},
               {old_text: 'Final Covers',  new_text: 'Final'},]

  # add and insert Update PSD task
  # it becomes (and remains) available after Final Covers
  def up
    final_covers = Task.find_by_name("Final Covers")
    return if final_covers.nil?

    # create Update PSD task
    new_task = Task.new
    new_task.name = 'Update PSD'
    new_task.tab_text = 'Update PSD'
    new_task.partial = 'update_psd'
    new_task.icon = 'icon-cloud-upload'
    new_task.next_id = nil
    new_task.team_only = true
    new_task.workflow = final_covers.workflow
    new_task.save

    # add Update PSD after Final Covers
    final_covers_tab = Tab.find_by_task_id(final_covers.id)
    new_tab = Tab.new
    new_tab.task = new_task
    new_tab.phase = final_covers_tab.phase
    new_tab.order = final_covers_tab.order + 1
    new_tab.save

    # adjust all remaining tabs
    remaining_tabs = new_tab.phase.tabs.joins(:task)
      .where("tabs.order >= ? and tasks.name != ? ", new_tab.order, new_task.name)
    remaining_tabs.each do | tab |
      tab.order = tab.order + 1
      tab.save
    end

    # unlock update_psd for everything beyond "Final Covers"
    task = final_covers
    while task.next_id
      task = Task.find(task.next_id)
      task.unlocked_tasks.create!(unlocked_task: new_task)
    end

    # retext some stuff so that the tabs will all fit in 1280px!
    @@renames.each do |rename|
      retext_tab(rename[:old_text], rename[:new_text])
    end
  end

  # Remove Update PSD Task
  def down
    # un-retext stuff
    @@renames.each do |rename|
      retext_tab(rename[:new_text], rename[:old_text])
    end

    task = Task.find_by_name('Update PSD')
    return if task.nil?

    # destroy tab
    Tab.find_by_task_id(task.id).destroy

    # remove from unlocked lists
    UnlockedTask.where(unlocked_task_id: task.id).destroy_all

    # destroy task
    task.destroy
  end
end
