class ProjectView < ActiveRecord::Base
  belongs_to :project_type
  has_many :phases
  
  accepts_nested_attributes_for :phases, reject_if: :all_blank, allow_destroy: true  
  
  validates :project_type, presence: true
  
end
