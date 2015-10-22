class NewManuscriptTabs < ActiveRecord::Migration
  def change

    # adjust column names to match what's already happening in the tabs
    rename_column :manuscripts, :proofed_file_name,              :proofread_complete_file_name
    rename_column :manuscripts, :proofed_file_size,              :proofread_complete_file_size
    rename_column :manuscripts, :proofed_content_type,           :proofread_complete_content_type
    rename_column :manuscripts, :proofed_updated_at,             :proofread_complete_updated_at
    rename_column :manuscripts, :proofed_file_direct_upload_url, :proofread_complete_file_direct_upload_url
    rename_column :manuscripts, :proofed_file_processed,         :proofread_complete_file_processed

    # new columns for proofed
    add_column :manuscripts, :proofed_file_name,              :string
    add_column :manuscripts, :proofed_file_size,              :integer
    add_column :manuscripts, :proofed_content_type,           :string
    add_column :manuscripts, :proofed_updated_at,             :datetime
    add_column :manuscripts, :proofed_file_direct_upload_url, :string
    add_column :manuscripts, :proofed_file_processed,         :boolean

    # new columns for proofed
    add_column :manuscripts, :first_pass_edit_file_name,              :string
    add_column :manuscripts, :first_pass_edit_file_size,              :integer
    add_column :manuscripts, :first_pass_edit_content_type,           :string
    add_column :manuscripts, :first_pass_edit_updated_at,             :datetime
    add_column :manuscripts, :first_pass_edit_file_direct_upload_url, :string
    add_column :manuscripts, :first_pass_edit_file_processed,         :boolean

    # find existing relevant tasks and tabs
    original_task = Task.find_by_name("Original Manuscript")
    original_tab = Tab.find_by_task_id(original_task.id)
    edited_task = Task.find_by_name("Edited Manuscript")
    edited_tab = Tab.find_by_task_id(edited_task.id)
    pcomplete_task = Task.find_by_name("Proofread Complete")
    pcomplete_tab = Tab.find_by_task_id(pcomplete_task.id)

    return unless original_task && original_tab &&
                  edited_task && edited_tab &&
                  pcomplete_task && pcomplete_tab

    # TTR-86: "First Pass Edit" goes after "Original Manuscript" and before "Edited Manuscript"
    reversible do |direction|
      direction.up do
        # task-fu
        fpe_task = Task.new(
          name: 'First Pass Edit',
          tab_text: 'First Pass Edit',
          partial: 'first_pass_edit',
          icon: 'icon-bookmark',
          next_id: edited_task.id,
          team_only: true,
          workflow: edited_task.workflow
        )
        fpe_task.save
        original_task.unlocked_tasks.create!(unlocked_task: fpe_task)

        # tab-fu
        original_tab.make_new_tab_after(fpe_task)
      end

      direction.down do
        fpe_task = Task.find_by_name('First Pass Edit')
        fpe_task.destroy if fpe_task  # before_destroy takes care of all cleanup
      end
    end

    # TTR-87: "Proofread Manuscript" goes after "Edited Manuscript" and before "Proofread Complete"
    reversible do |direction|
      direction.up do
        # task-fu
        pm_task = Task.new(
          name: 'Proofread Manuscript',
          tab_text: 'Proofread Manuscript',
          partial: 'proofread_manuscript',
          icon: 'icon-bookmark',
          next_id: pcomplete_task.id,
          team_only: true,
          workflow: pcomplete_task.workflow
        )
        pm_task.save
        edited_task.unlocked_tasks.create!(unlocked_task: pm_task)

        # tab-fu
        edited_tab.make_new_tab_after(pm_task)
      end

      direction.down do
        pm_task = Task.find_by_name('Proofread Manuscript')
        pm_task.destroy if pm_task  # before_destroy takes care of all cleanup
      end
    end
  end
end
