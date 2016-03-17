class AddCreateLegalDocTask < ActiveRecord::Migration
  def up

    # fetch the team_change_task
    team_change_task = Task.find_by_name("Team Change")

    # punt if task not found (happens when starting with a fresh db
    # the task will then be defined in seeds.rb)
    return if team_change_task.nil?

    create_legal_doc_task = Task.create(
      name: "Legal Import",
      tab_text: "Legal Import",
      workflow: team_change_task.workflow,
      icon: "icon-file-alt",
      team_only: true,
      partial: "import_legal_doc"
    )

    # copy permissions from team change
    UnlockedTask.includes(:task)
      .where(unlocked_task: team_change_task).find_each do | unlocked_task |
      task = unlocked_task.task
      task.unlocked_tasks.create(unlocked_task: create_legal_doc_task)
    end

    # set the performers
    #TODO add the performers once signed off on https://teamtrope.atlassian.net/browse/TTR-319

    # ---- Add the tab to the project view ----
    team_change_tab = Tab.find_by_task_id(team_change_task.id)

    return if team_change_tab.nil?

    create_legal_doc_tab = Tab.create(
      task: create_legal_doc_task,
      phase: team_change_tab.phase,
      order: team_change_tab.order + 1
    )
  end

  def down
    create_legal_doc_task = Task.find_by_name("Legal Import")
    create_legal_doc_tab = Tab.find_by_task_id(create_legal_doc_task.id)

    return if create_legal_doc_task.nil? || create_legal_doc_tab.nil?

    create_legal_doc_tab.destroy
    create_legal_doc_task.destroy
  end
end
