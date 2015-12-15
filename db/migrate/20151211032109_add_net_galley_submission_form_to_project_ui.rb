class AddNetGalleySubmissionFormToProjectUi < ActiveRecord::Migration
  def up
    blog_tour = Task.find_by_name("Blog Tour")
    return if blog_tour.nil?

    # create the new task
    netgalley_submission_task = Task.create(
      name: 'Netgalley Submission',
      tab_text: 'Netgalley Submission',
      partial: 'netgalley_submission_form',
      icon: 'icon-money',
      team_only: true
    )

    # copy blog tour's performers
    blog_tour.task_performers.each do | task_performer |
      netgalley_submission_task.task_performers.create(role: task_performer.role)
    end

    # copy the unlocked tasks from the blog tour
    UnlockedTask.where(unlocked_task: blog_tour).each do | unlocked_task |
      unlocked_task.task.unlocked_tasks.create(unlocked_task: netgalley_submission_task)
    end

    # swap blog tour container tab's pointer to point to Netgalley Submission
    blog_tour_to_netgalley_tab = Tab.find_by_task_id(blog_tour.id)
    blog_tour_to_netgalley_tab.task = netgalley_submission_task

    blog_tour_to_netgalley_tab.save
  end

  def down
    blog_tour = Task.find_by_name("Blog Tour")
    netgalley_submission_task = Task.find_by_name("Netgalley Submission")

    return if blog_tour.nil? || netgalley_submission_task.nil?

    # load the netgalley containing tab and swap netgalley with blog tour tab
    netgalley_to_blog_tour_tab = Tab.find_by_task_id(netgalley_submission_task.id)
    netgalley_to_blog_tour_tab.task = blog_tour
    netgalley_to_blog_tour_tab.save

    # destroy unnecessary data.
    UnlockedTask.where(unlocked_task: netgalley_submission_task).destroy_all
    netgalley_submission_task.task_performers.destroy_all

  end
end
