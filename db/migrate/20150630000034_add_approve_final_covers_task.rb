class AddApproveFinalCoversTask < ActiveRecord::Migration

  def up

    # Add the approval flag & notes fields
    add_column :cover_templates, :final_cover_approved, :boolean
    add_column :cover_templates, :final_cover_approval_date, :date
    add_column :cover_templates, :final_cover_notes, :text

    # Add new task - Set the next task to id from Final Covers
    # Update next task for Final Covers to new task id

    final_covers = Task.find_by_name('Final Covers')

    return if final_covers.nil?

    new_task = Task.new
    new_task.name = 'Approve Final Covers'
    new_task.tab_text = 'Approve Final'
    new_task.partial = 'approve_final_cover'
    new_task.icon = 'icon-thumbs-up'
    new_task.next_task = final_covers.next_task
    new_task.rejected_task = final_covers
    new_task.team_only = true
    new_task.workflow = final_covers.workflow
    new_task.save

    # Copy the unlocked tasks from final covers
    final_covers.unlocked_tasks.each do |task|
      new_task.unlocked_tasks.create!(unlocked_task: task.unlocked_task) unless task.unlocked_task.name == 'Final Covers'
    end
  end

  def down

    # Remove the Approve Covers task and associate Final Covers with the Design Complete task
    approve_covers = Task.find_by_name('Approve Final Covers')

    final_covers = Task.find_by_name('Final Covers')
    final_covers.next_task = approve_covers.next_task
    final_covers.save

    # Find the related tab
    tab = Tab.find_by_task_id(approve_covers.id)

    tab.destroy
    approve_covers.destroy

    # Move Artwork Rights back one item
    artwork_rights_task = Task.find_by_name('Artwork Rights Request')
    artwork_rights_tab = Tab.find_by_task_id(artwork_rights_task.id)
    artwork_rights_tab.order = artwork_rights_tab.order + -1
    artwork_rights_tab.save

    # Remove the approval flag & notes fields
    remove_column :cover_templates, :final_cover_approved, :boolean
    remove_column :cover_templates, :final_cover_approval_date, :date
    remove_column :cover_templates, :final_cover_notes, :text

  end
end
