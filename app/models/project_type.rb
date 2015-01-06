class ProjectType < ActiveRecord::Base

	has_many :project_type_workflows, foreign_key: :project_type_id, dependent: :destroy
	has_many :workflows, through: :project_type_workflows, source: :workflow

end
