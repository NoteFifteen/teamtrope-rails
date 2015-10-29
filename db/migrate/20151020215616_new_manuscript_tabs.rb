class NewManuscriptTabs < ActiveRecord::Migration
  def change

    # find existing relevant tasks and tabs
    original_task = Task.find_by_name("Original Manuscript")
    original_tab = Tab.find_by_task_id(original_task.id)
    edited_task = Task.find_by_name("Edited Manuscript")
    edited_tab = Tab.find_by_task_id(edited_task.id)
    pcomplete_task = Task.find_by_name("Proofread Complete")
    pcomplete_tab = Tab.find_by_task_id(pcomplete_task.id)

    editor_role = Role.find_by_name("Editor")
    author_role = Role.find_by_name("Author")

    return unless original_task && original_tab &&
                  edited_task && edited_tab &&
                  pcomplete_task && pcomplete_tab &&
                  editor_role && author_role

    # make these names consistent
    rename_column :cover_concepts, :cover_concept_image_direct_upload_url, :cover_concept_direct_upload_url
    rename_column :cover_concepts, :cover_concept_image_processed, :cover_concept_processed

    # ignore _processed vs. _file_processed inconsistency for now...

    # adjust column names to match what's already happening in the tabs
    rename_column :manuscripts, :proofed_file_name,              :proofread_complete_file_name
    rename_column :manuscripts, :proofed_file_size,              :proofread_complete_file_size
    rename_column :manuscripts, :proofed_content_type,           :proofread_complete_content_type
    rename_column :manuscripts, :proofed_updated_at,             :proofread_complete_updated_at
    rename_column :manuscripts, :proofed_file_direct_upload_url, :proofread_complete_file_direct_upload_url
    rename_column :manuscripts, :proofed_file_processed,         :proofread_complete_file_processed

    # new columns for proofed--reusing the name makes it harder to debug :-\
    add_column :manuscripts, :proofed_file_name,              :string
    add_column :manuscripts, :proofed_file_size,              :integer
    add_column :manuscripts, :proofed_content_type,           :string
    add_column :manuscripts, :proofed_updated_at,             :datetime
    add_column :manuscripts, :proofed_file_direct_upload_url, :string
    add_column :manuscripts, :proofed_file_processed,         :boolean

    # new columns for first_pass_edit
    add_column :manuscripts, :first_pass_edit_file_name,              :string
    add_column :manuscripts, :first_pass_edit_file_size,              :integer
    add_column :manuscripts, :first_pass_edit_content_type,           :string
    add_column :manuscripts, :first_pass_edit_updated_at,             :datetime
    add_column :manuscripts, :first_pass_edit_file_direct_upload_url, :string
    add_column :manuscripts, :first_pass_edit_file_processed,         :boolean

    # clean up some naming
    reversible do |direction|
      direction.up do
        pcomplete_task.partial = 'proofread_complete'
      end
      direction.down do
        pcomplete_task.partial = 'submit_proofread'
      end
    end

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
          workflow: edited_task.workflow,
          unlocked: original_task.unlocked
        )
        fpe_task.save
        fpe_task.performers << editor_role
        original_task.unlocked_tasks.create!(unlocked_task: fpe_task)

        # tab-fu
#        original_tab.make_new_tab_after(fpe_task)
      end

      direction.down do
        fpe_task = Task.find_by_name('First Pass Edit')
        fpe_task.destroy if fpe_task  # before_destroy takes care of all cleanup
      end
    end

    # TTR-87: "Proofed Manuscript" goes after "Edited Manuscript" and before "Proofread Complete"
    reversible do |direction|
      direction.up do
        # task-fu
        pm_task = Task.new(
          name: 'Proofed Manuscript',
          tab_text: 'Proofed Manuscript',
          partial: 'proofed_manuscript',
          icon: 'icon-bookmark',
          next_id: pcomplete_task.id,
          team_only: true,
          workflow: pcomplete_task.workflow,
          unlocked: edited_task.unlocked
        )
        pm_task.save
        pm_task.performers << author_role
        edited_task.unlocked_tasks.create!(unlocked_task: pm_task)

        # tab-fu
        edited_tab.make_new_tab_after(pm_task)
      end

      direction.down do
        pm_task = Task.find_by_name('Proofed Manuscript')
        pm_task.destroy if pm_task  # before_destroy takes care of all cleanup
      end
    end
  end
end
