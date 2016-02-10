class PublicationFactSheet < ActiveRecord::Base
  belongs_to :project

  after_initialize :custom_init

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

  def custom_init
    return if project.nil?

    self.author_name ||= project.authors.map(&:member).map(&:name).join(",")

    # if the pfs exists (which it will on submit pfs since update page count creates it)
    # override the empty description with the draft blurb
    self.description = nil if self.description.strip == ""
    self.description ||= project.try(:draft_blurb).try(:draft_blurb)

  end

  def starting_grade_level
    unless self.starting_grade_index.nil? ||
      self.starting_grade_index > GRADE_LEVELS.count ||
      self.starting_grade_index < 0
      GRADE_LEVELS[self.starting_grade_index]
    end
  end
end
