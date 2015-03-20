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
  
end
