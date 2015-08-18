# Task 540 requests that we allow cover art to be uploaded all the way up until the final covers are uploaded
class AllowUpdateCovers < ActiveRecord::Migration

  Tasks = ['Approve Cover Art', 'Final Covers']

  def change
    cover_concept = Task.find_by_name('Cover Concept')

    return if cover_concept.nil?

    Tasks.each do |task_name|
      task = Task.find_by_name(task_name)
        unless task.nil?
          unlocked_task = UnlockedTask.new
          unlocked_task.task_id = task.id
          unlocked_task.unlocked_task = cover_concept
          unlocked_task.save
        end
    end

  end

end
