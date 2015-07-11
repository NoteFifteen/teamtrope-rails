class RemoveMarketingReleaseDate < ActiveRecord::Migration

  # Task 617 - Remove "Marketing Release Date" form from the Project.
  def change

    # Drop the column
    remove_column :projects, :marketing_release_date, :datetime

    # Now drop all of the associated tab/task/dependencies
    task = Task.find_by_name('Market Release Date')

    unless ! task.nil?

      # Identify the tab
      market_tab = Tab.find_by_task_id(task.id)

      # Update the proceeding tabs' tab order (have to qualify the column name since we used a reserved SQL keyword)
      Tab.where(:phase_id => 4).where('tabs.order > ?', market_tab.order).each do |tab|
        tab.order = tab.order - 1
        tab.save!
      end

      # Remove the market tab
      market_tab.destroy

      # Remove all associated task performer records
      TaskPerformer.where(:task_id => task.id).destroy_all

      # Remove all unlocked_task records where the Market Release Date task was unlocked
      UnlockedTask.where(:unlocked_task_id => task.id).destroy_all

      # Finally, destroy the task itself
      task.destroy
    end
  end
end
