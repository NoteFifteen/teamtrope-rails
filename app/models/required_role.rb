class RequiredRole < ActiveRecord::Base
  belongs_to :role
  belongs_to :project_type
end
