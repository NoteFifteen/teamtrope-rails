class AddUnapprovedCoverToCoverConcepts < ActiveRecord::Migration
  def change
    add_attachment :cover_concepts, :unapproved_cover_concept
  end
end
