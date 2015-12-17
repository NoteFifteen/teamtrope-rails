class AddProofedMauscriptTask < ActiveRecord::Migration
  def up
    edited_manuscript = Task.find_by_name("In Editing")
    proofread_complete = Task.find_by_name("In Proofreading")
    return if edited_manuscript.nil? || proofread_complete.nil?

    # create new task
    proofed_manuscript = Task.create(
      name: 'Proofed Manuscript',
      tab_text: 'Proofed Manuscript',
      partial: 'proofed_manuscript',
      icon: 'icon-edit',
      team_only: true
    )

    # add performer roles
    Role.where(name: ["Author", "Book Manager", "Proofreader"]).each do | role |
      proofed_manuscript.task_performers.create(role: role)
    end

    # update the unlocked tasks
    UnlockedTask.includes(:task).where(unlocked_task: proofread_complete).map(&:task).each do | task |
      task.unlocked_tasks.create(unlocked_task: proofed_manuscript)
    end

    # create the tab and insert it.
    edited_manuscript_tab = Tab.find_by_task_id(edited_manuscript.id)
    phase = edited_manuscript_tab.phase
    order = edited_manuscript_tab.order

    proofed_manuscript_tab = edited_manuscript_tab.make_new_tab_after(proofed_manuscript)

  end

  def down
    proofed_manuscript = Task.find_by_name("Proofed Manuscript")
    return if proofed_manuscript.nil?

    #retrieve the tab
    proofed_manuscript_tab = Tab.find_by_task_id(proofed_manuscript.id)

    proofed_manuscript_tab.move_subsequent_tabs_left

    UnlockedTask.where(unlocked_task: proofed_manuscript).destroy_all

    proofed_manuscript.task_performers.destroy_all
    proofed_manuscript.destroy
    proofed_manuscript_tab.destroy

  end
end
