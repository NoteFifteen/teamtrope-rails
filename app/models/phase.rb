class Phase < ActiveRecord::Base

	belongs_to :project_view
	has_many :tabs
	
	accepts_nested_attributes_for :tabs, reject_if: :all_blank, allow_destroy: true
	
	default_scope -> { order(:order) }
	
end
