class AddNewWorkflowToStandardProject < ActiveRecord::Migration
  def up
    # looking up the Assets task
    assets_task = Task.find_by_name 'Assets'

    # remove former unlocked tasks
    UnlockedTask.where(unlocked_task_id: assets_task.id).destroy_all

    # looking up the standard project so we can attach the new workflow to it.
    standard_project = ProjectType.find_by_name 'Standard Project'

    return if standard_project.nil? || assets_task.nil?

    # create the new workflow
    download_workflow = Workflow.create name: 'Download'

    # create the new workflow tasks
    accepted_task = download_workflow.tasks.create name: 'Accepted'
    accepted_task.unlocked_tasks.create unlocked_task_id: assets_task.id

    accept_terms_task = download_workflow.tasks.create(
      name: 'Accept Terms',
      tab_text: 'Accept Terms to Download Files',
      next_id: accepted_task.id,
      partial: 'download_your_files',
      team_only: true,
      icon: 'icon-file'
    )

    # add task performers
    author = Role.find_by_name 'Author'

    accept_terms_task.task_performers.create role_id: author.id

    # set the root task of our new workflow to accept terms
    download_workflow.update_attributes root_task_id: accept_terms_task.id

    # add the new workflow to the standard_project
    standard_project.project_type_workflows.create workflow_id: download_workflow.id

    # set the current task for each project to be our new accept terms task.
    Project.find_each do |project|
      project.current_tasks.create task_id: accept_terms_task.id
    end

    # create the tab and add our new task to the view.
    # get the new tab
    assets_tab = Tab.find_by_task_id assets_task.id

    return if assets_tab.nil? # if this is nil that means our database is messed

    # insert the new tab into the workflow
    accept_terms_tab = assets_tab.make_new_tab_after accept_terms_task

    add_column :project_grid_table_rows, :download_task_id, :string
    add_column :project_grid_table_rows, :download_task_name, :string
    add_column :project_grid_table_rows, :download_task_display_name, :string
    add_column :project_grid_table_rows, :download_task_last_update, :string

  end

  def down
    download_workflow = Workflow.find_by_name 'Download'
    accepted_task = Task.find_by_name 'Accepted'
    accept_terms_task = Task.find_by_name 'Accept Terms'

    accept_terms_tab = Tab.find_by_task_id accept_terms_task.id
    accept_terms_tab.move_subsequent_tabs_left
    accept_terms_tab.destroy
    CurrentTask.where(task_id: [accept_terms_task.id, accepted_task.id]).destroy_all

    download_workflow.destroy
    accepted_task.destroy
    accept_terms_task.destroy

    remove_column :project_grid_table_rows, :download_task_id, :string
    remove_column :project_grid_table_rows, :download_task_name, :string
    remove_column :project_grid_table_rows, :download_task_display_name, :string
    remove_column :project_grid_table_rows, :download_task_last_update, :string
  end
end
