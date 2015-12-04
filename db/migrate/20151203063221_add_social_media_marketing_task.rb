class AddSocialMediaMarketingTask < ActiveRecord::Migration
  def up

    pricing_and_promos = Task.find_by_name("Promos")
    return if pricing_and_promos.nil?

    #creating the new tasks
    social_media_marketing_view = Task.new
    social_media_marketing_view.name = 'Social Media Marketing View'
    social_media_marketing_view.tab_text = 'Social Media'
    social_media_marketing_view.partial = 'social_media_marketing_view'
    social_media_marketing_view.icon = 'icon-file-alt'
    social_media_marketing_view.team_only = false
    social_media_marketing_view.save

    social_media_marketing_edit = Task.new
    social_media_marketing_edit.name = 'Social Media Marketing Edit'
    social_media_marketing_edit.tab_text = 'Update Social Media'
    social_media_marketing_edit.partial = 'social_media_marketing_edit'
    social_media_marketing_edit.icon = 'icon-cogs'
    social_media_marketing_edit.save

    # add performer roles to social_media_marketing_edit
    performers = Role.where(name: ['Author', 'Book Manager'])

    performers.each do | performer |
      social_media_marketing_edit.task_performers.create(role: performer)
    end

    # update unlocked tasks
    production_workflow = Workflow.find_by_name('Production')
    production_workflow.tasks.each do | task |
      task.unlocked_tasks.create(unlocked_task: social_media_marketing_view)
      task.unlocked_tasks.create(unlocked_task: social_media_marketing_edit)
    end



    #Creating the tabs and add the view task tab after 'Pricing and Promos'
    pricing_and_promos_tab = Tab.find_by_task_id(pricing_and_promos.id)
    phase = pricing_and_promos_tab.phase
    order = pricing_and_promos_tab.order

    social_media_marketing_view_tab = Tab.new
    social_media_marketing_view_tab.task = social_media_marketing_view
    social_media_marketing_view_tab.phase = phase
    social_media_marketing_view_tab.order = order + 1
    social_media_marketing_view_tab.save

    social_media_marketing_edit_tab = Tab.new
    social_media_marketing_edit_tab.task = social_media_marketing_edit
    social_media_marketing_edit_tab.phase = phase
    social_media_marketing_edit_tab.order = order + 2
    social_media_marketing_edit_tab.save

    # adjust all remaining tabs
    remaining_tabs = phase.tabs.joins(:task)
      .where("tabs.order >= ? and (tasks.name != ? or tasks.name != ?)", order + 2, social_media_marketing_view.name, social_media_marketing_edit.name)

    remaining_tabs.each do | tab |
      tab.order = tab.order + 2
      tab.save
    end

  end

  #remove the tasks
  def down
    pricing_and_promos = Task.find_by_name('Promos')
    social_media_marketing_view = Task.find_by_name('Social Media Marketing View')
    social_media_marketing_edit = Task.find_by_name('Social Media Marketing Edit')

    return if pricing_and_promos.nil? || social_media_marketing_edit.nil? || social_media_marketing_view.nil?

    #retreive the tabs
    social_media_marketing_view_tab = Tab.find_by_task_id(social_media_marketing_view)
    social_media_marketing_edit_tab = Tab.find_by_task_id(social_media_marketing_edit)

    remaining_tabs = social_media_marketing_edit_tab.phase.tabs
      .joins(:task)
      .where("tabs.order > ?", social_media_marketing_edit_tab.order)

    # move all remaining tabs over by 1
    remaining_tabs.each do | remaining_tab |
      remaining_tab.order = remaining_tab.order - 2
      remaining_tab.save
    end

    #destroy the unnecessary data.
    UnlockedTask.where(unlocked_task: social_media_marketing_view).destroy_all
    UnlockedTask.where(unlocked_task: social_media_marketing_edit).destroy_all

    social_media_marketing_edit.task_performers.destroy_all
    social_media_marketing_edit.destroy
    social_media_marketing_edit_tab.destroy

    social_media_marketing_view.destroy
    social_media_marketing_view_tab.destroy

  end
end
