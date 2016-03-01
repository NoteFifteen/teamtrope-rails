class AddGenreToProject < ActiveRecord::Migration
  def change
    add_reference :projects, :genre, index: true

    Project.find_each do | project |
      project.update_attributes(genre: project.genres.first) unless project.genres.first.nil?
    end

  end
end
