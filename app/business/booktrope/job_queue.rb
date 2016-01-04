module Booktrope
  # a job queue that runs tasks asyncronously
  # jobs can either be an object that implements a function called
  # `perform` or a block.
  # call perform_blocks to perform the block
  # call perform_tasks to run the perform method
  # in the future it might be great to update this so that it supports a mixed
  # queue so that it can run blocks and task objects via one function.
  class JobQueue
    attr_accessor :queue, :workers, :workers_count

    # max workers count defaults to 5.
    def initialize
      @queue = Queue.new
      @workers = []
      @workers_count = 5
    end

    # enqueue the task
    def add_task(task)
      @queue << task
    end

    # base function that creates the threads and executes the task
    def execute_with_block
      @workers_count.times do | n |
        @workers << Thread.new(n+1) do | thread_id |
          while (task = @queue.shift(true) rescue nil) do
            yield(thread_id, task) if block_given?
          end
        end
      end
      @workers.each(&:join)
    end

    # execute the queue with the blocks
    def perform_blocks
      execute_with_block do | thread_id, task |
        task.call(thread_id)
      end
    end

    # execute the queue and envoke each task's perform function.
    def perform_tasks
      execute_with_block do | thread_id, task |
        if task.respond_to? :perform
          puts "worker ##{thread_id}"
          task.perform
        else
          raise '#{task.class} does not respond to perform'
        end
      end
    end
  end
end
