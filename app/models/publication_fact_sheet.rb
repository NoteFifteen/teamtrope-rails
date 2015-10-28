class PublicationFactSheet < ActiveRecord::Base
  belongs_to :project

  AGE_RANGES =
  [
    ['grade_school', 'Grade School'],
    ['middle_school', 'Middle School'],
    ['high_school', 'High School'],
    ['general_adult', 'General Adult'],
    ['mature_adult', 'Mature Adult']
  ]

  COVER_TYPES =
  [
    ['matte', 'Matte'],
    ['glossy', 'Glossy']
  ]

  GRADE_LEVELS =
  [
    "Pre-K",
    "Kindergarten",
    "1st Grade",
    "2nd Grade",
    "3rd Grade",
    "4th Grade",
    "5th Grade",
    "6th Grade",
    "7th Grade",
    "8th Grade",
    "9th Grade",
    "10th Grade",
    "11th Grade",
    "12th Grade"
  ]

  def starting_grade_level
    unless self.starting_grade_index.nil? ||
      self.starting_grade_index > GRADE_LEVELS.count ||
      self.starting_grade_index < 0
      GRADE_LEVELS[self.starting_grade_index]
    end
  end
end
