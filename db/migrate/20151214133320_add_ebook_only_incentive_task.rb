class AddEbookOnlyIncentiveTask < ActiveRecord::Migration
  def up

    print_task = Task.find_by_name("Print")
    return if print_task.nil?

    # create the new task
    ebook_only_incentive_task = Task.create(
      name: 'eBook Only Incentive',
      tab_text: 'eBook Only Incentive',
      partial: 'ebook_only_incentive',
      icon: 'icon-book',
      team_only: true,
    )

    # add performer roles to ebook_only_incentive_task
    Role.where(name: ["Author", "Book Manager"]).each do | role |
      ebook_only_incentive_task.task_performers.create(role: role)
    end

    # update unlocked tasks
    UnlockedTask.includes(:task).where(unlocked_task: print_task).map(&:task).each do | task |
      task.unlocked_tasks.create(unlocked_task: ebook_only_incentive_task)
    end

    # create the tab and insert it into the view
    print_tab = Tab.find_by_task_id(print_task.id)
    phase = print_tab.phase
    order = print_tab.order

    ebook_only_incentive_tab = Tab.create(
      task: ebook_only_incentive_task,
      phase: phase,
      order: order + 1
    )

    # adjust all remaining tabs
    remaining_tabs = phase.tabs.joins(:task)
      .where("tabs.order >= ? and tasks.name != ?", order + 1, ebook_only_incentive_task.name)

    remaining_tabs.each do | tab |
      tab.order = tab.order + 1
      tab.save
    end

  end

  def down
    netgalley_submission = Task.find_by_name("Netgalley Submission")
    ebook_only_incentive_task = Task.find_by_name("eBook Only Incentive")

    return if netgalley_submission.nil? || ebook_only_incentive_task.nil?

    #retreive the tab
    ebook_only_incentive_tab = Tab.find_by_task_id(ebook_only_incentive_task.id)

    remaining_tabs = ebook_only_incentive_tab.phase.tabs
      .joins(:task)
      .where("tabs.order > ?", ebook_only_incentive_tab.order)

    # move all remaining tabs over by 1
    remaining_tabs.each do | remaining_tab |
      remaining_tab.order = remaining_tab.order - 1
      remaining_tab.save
    end

    # destroy the unncessary data.
    UnlockedTask.where(unlocked_task: ebook_only_incentive_task).destroy_all

    ebook_only_incentive_task.task_performers.destroy_all
    ebook_only_incentive_task.destroy
    ebook_only_incentive_tab.destroy

  end

end
