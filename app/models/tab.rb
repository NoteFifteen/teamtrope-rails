class Tab < ActiveRecord::Base
  belongs_to :task
  belongs_to :phase
  
  default_scope -> { order(:order) }
  
end
