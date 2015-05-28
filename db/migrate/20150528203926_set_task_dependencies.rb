class SetTaskDependencies < ActiveRecord::Migration
  DependencyAdditions = [
      { task: 'Final Covers', dependencies: ["Page Count"] },
      { task: 'Submit PFS',   dependencies: ["Final Covers"] },
      { task: 'Publish Book', dependencies: ["Final Covers", "Submit PFS"] }
  ]

  # add the dependencies to task_dependencies
  def up
    enumerate_task_dependencies do | task, dependent_task |
      task.task_dependencies.build(dependent_task_id: dependent_task.id)
      task.save
    end
  end

  # remove the dependencies from task_dependencies
  def down
    enumerate_task_dependencies do | task, dependent_task |
      task.task_dependencies.where(dependent_task_id: dependent_task.id)
      .first.destroy
    end
  end

  # since getting the task and dependent tasks are exactly the same for up and
  # down it's better to break them into a function that takes a block to perform
  # the variant task thus keeping our code DRY.
  def enumerate_task_dependencies
    DependencyAdditions.each do | addition |
      task = Task.find_by_name(addition[:task])
      next if task.nil?
      addition[:dependencies].each do | dependency |
        dependent_task = Task.find_by_name(dependency)
        next if dependent_task.nil?
        # call yield to execute the code from the block
        yield(task, dependent_task)
      end
    end
  end
end
