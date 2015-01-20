class ProjectView < ActiveRecord::Base
  belongs_to :project_type
  has_many :phases
  
end
