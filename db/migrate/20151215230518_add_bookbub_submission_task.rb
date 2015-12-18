class AddBookbubSubmissionTask < ActiveRecord::Migration
  def up

    # Create before
    pricing_and_promos = Task.find_by_name("Promos")
    return if pricing_and_promos.nil?

    #creating the new tasks
    bookbub_submission = Task.new
    bookbub_submission.name = 'Bookbub Submission'
    bookbub_submission.tab_text = 'Bookbub Submission'
    bookbub_submission.partial = 'bookbub_submission'
    bookbub_submission.icon = 'icon-file-alt'
    bookbub_submission.save

    # add performer roles to bookbub_submission
    performers = Role.where(name: ['Author', 'Book Manager'])

    performers.each do | performer |
      bookbub_submission.task_performers.create(role: performer)
    end

    # update unlocked tasks
    production_complete = Task.find_by_name('Production Complete')
    production_complete.unlocked_tasks.create(unlocked_task: bookbub_submission)


    #Creating the tabs and add the view task before after 'Pricing and Promos'
    pricing_and_promos_tab = Tab.find_by_task_id(pricing_and_promos.id)
    phase = pricing_and_promos_tab.phase
    order = pricing_and_promos_tab.order

    bookbub_submission_tab = Tab.new
    bookbub_submission_tab.task = bookbub_submission
    bookbub_submission_tab.phase = phase
    bookbub_submission_tab.order = order
    bookbub_submission_tab.save

    # adjust all remaining tabs
    remaining_tabs = phase.tabs.joins(:task)
                         .where("tabs.order >= ? and (tasks.name != ?)", order, bookbub_submission.name)

    remaining_tabs.each do | tab |
      tab.order = tab.order + 1
      tab.save
    end

  end

  #remove the tasks
  def down
    pricing_and_promos = Task.find_by_name('Promos')
    bookbub_submission = Task.find_by_name('Bookbub Submission')

    return if pricing_and_promos.nil? || bookbub_submission.nil?

    #retreive the tabs
    bookbub_submission_tab = Tab.find_by_task_id(bookbub_submission)

    remaining_tabs = bookbub_submission_tab.phase.tabs
                         .joins(:task)
                         .where("tabs.order > ?", bookbub_submission_tab.order)

    # move all remaining tabs over by 1
    remaining_tabs.each do | remaining_tab |
      remaining_tab.order = remaining_tab.order - 1
      remaining_tab.save
    end

    #destroy the unnecessary data.
    UnlockedTask.where(unlocked_task: bookbub_submission).destroy_all

    bookbub_submission.task_performers.destroy_all
    bookbub_submission.destroy
    bookbub_submission_tab.destroy

  end
end
