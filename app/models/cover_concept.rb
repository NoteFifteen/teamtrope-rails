class CoverConcept < ActiveRecord::Base
  belongs_to :project

  has_attached_file :cover_concept
  has_attached_file :stock_cover_image

  # Validates that files are JPEG
  validates_attachment :cover_concept,
                       *Constants::DefaultContentTypeImageParams

  validates_attachment :stock_cover_image,
                       *Constants::DefaultContentTypeImageParams

end