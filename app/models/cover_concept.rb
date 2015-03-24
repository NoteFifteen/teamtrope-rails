class CoverConcept < ActiveRecord::Base
  belongs_to :project

  has_attached_file :cover_concept

  # Validates that files are JPEG
  validates_attachment :cover_concept,
                       *Constants::DefaultContentTypeImageParams

end
