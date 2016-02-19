class AddSubmitToLayoutTab < ActiveRecord::Migration
  def up

    # We are combining two tasks into one Proofread Complete and Choose Style

    # fetch the old task that we will remove from the workflow
    proofread_compelete_task = Task.find_by_name("Proofread Complete")

    # get the task that points to it
    previous_task = Task.find_by_next_id(proofread_compelete_task.id)

    # get the choose style task
    choose_style_task = Task.find_by_name("Choose Style")

    return if proofread_compelete_task.nil? || previous_task.nil? || choose_style_task.nil?

    # create the new task
    submit_to_layout_task = Task.create(
      name: "Submit to Layout",
      tab_text: "Submit to Layout",
      icon: "icon-ok-sign",
      partial: "submit_to_layout",
      workflow: proofread_compelete_task.workflow,
      next_task: choose_style_task.next_task
    )

    # isolate choose style task and proofread complete by removing its next id
    choose_style_task.update_attributes(next_id: nil)
    proofread_compelete_task.update_attributes(next_id: nil)

    # copy the performers
    proofread_compelete_task.task_performers.each do | task_performer |
      submit_to_layout_task.task_performers.create(role: task_performer.role)
    end

    # copy the unlocked tasks for proofread_complete to submit to layout
    UnlockedTask.where(unlocked_task: proofread_compelete_task).each do | unlocked_task |
      unlocked_task.task.unlocked_tasks.create(unlocked_task: submit_to_layout_task)
    end

    # copy proofread_compelete_task's unlocked tasks
    proofread_compelete_task.unlocked_tasks.each do | unlocked_task |
      submit_to_layout_task.unlocked_tasks.create(unlocked_task: unlocked_task.unlocked_task)
    end

    # update the current tasks pointing at proofread_compelete_task to submit_to_layout_task
    CurrentTask.where(task_id: proofread_compelete_task.id).each do | current_task |
      current_task.task = submit_to_layout_task
      current_task.save
    end

    # update the current tasks pointing at choose_style_task to submit_to_layout_task
    # we are doing this because the tasks have been combined into one thus tasks that
    # are in choose_layout will be imcomplete. (NOTE: this can't be undone in the down
    # because it's indeterministic what they used to point to. If we want that we would
    # have to create a record of what they used to point to in the db.)
    CurrentTask.where(task_id: choose_style_task.id).each do | current_task |
      current_task.task = choose_style_task.next_task
      current_task.save
    end

    # update the previous task to point to our new task
    previous_task.next_task = submit_to_layout_task
    previous_task.save

    # update the user interface to show our new tab.
    tab = Tab.find_by_task_id(proofread_compelete_task.id)

    tab.task = submit_to_layout_task
    tab.save

    # remove choose layout tab from UI
    choose_style_tab = Tab.find_by_task_id(choose_style_task.id)
    choose_style_tab.move_subsequent_tabs_left

    choose_style_tab.destroy
  end

  def down

    # since we didn't delete the task we can resurrect it and point it back to workflow
    proofread_compelete_task = Task.find_by_name("Proofread Complete")
    submit_to_layout_task = Task.find_by_name("Submit to Layout")

    # find the previous task
    previous_task = Task.find_by_next_id(submit_to_layout_task.id)

    return if proofread_compelete_task.nil? || submit_to_layout_task.nil? || previous_task.nil?


    # rewire the previous task to point to the proofread_compelete_task
    previous_task.next_task = proofread_compelete_task
    previous_task.save

    # set the current tasks that pointed to submit_to_layout_task back to point to proofread_compelete_task
    CurrentTask.where(task_id: submit_to_layout_task.id).each do | current_task |
      current_task.task = proofread_compelete_task
      current_task.save
    end

    # update that tab to point back to proofread complete
    tab = Tab.find_by_task_id(submit_to_layout_task.id)
    tab.task = proofread_compelete_task
    tab.save

    # add the choose style tab back
    choose_style_task = Task.find_by_name("Choose Style")

    upload_layout_tab = Tab.find_by_task_id(Task.find_by_name("Upload Layout"))

    choose_style_tab = Tab.create(
      task: choose_style_task,
      phase: upload_layout_tab.phase,
      order: 1
    )

    # add the old tasks back to the workflow
    proofread_compelete_task.update_attributes(next_id: choose_style_task.id)


    choose_style_tab.make_space_after

    # set choose_style_task's next pointer to submit_layout_task's next pointer
    choose_style_task.update_attributes(next_id: submit_to_layout_task.next_id)

    submit_to_layout_task.destroy

  end
end
