class Phase < ActiveRecord::Base

	belongs_to :project_view
	has_many :tabs
	
	default_scope -> { order(:order) }
	
end
