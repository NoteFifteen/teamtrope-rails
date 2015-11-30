module Booktrope
  class JobQueue
    attr_accessor :queue, :workers, :workers_count

    def initialize
      @queue = Queue.new
      @workers = []
      @workers_count = 5
    end

    def add_task(task)
      @queue << task
    end

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

    def perform_blocks
      execute_with_block do | thread_id, task |
        task.call(thread_id)
      end
    end

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
