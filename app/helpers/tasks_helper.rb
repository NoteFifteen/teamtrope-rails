module TasksHelper

  # The the partial that gets rendered on projects/show varies based upon the the task.
  # load_partials loads all partials in app/views/projects/forms and return an array of
  # arrays. The nested arrays represent the human readable name and file name respectively.
  # the return array is passed to the rails form helper .select
  def load_partials
    partials_path = Rails.root.join("app", "views", "projects", "forms")
    partials = Array.new

    Dir.foreach(partials_path) do | partial |
      if partial.end_with? ".erb"
        partial.gsub!(/^_/,"").gsub!(/\.html\.erb/,"")
        partials.push([partial.gsub(/_/, " ").titleize, partial])
      end
    end
    partials
  end
end
