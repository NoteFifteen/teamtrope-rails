class ControlNumber < ActiveRecord::Base
  # A control number is used to track the various identifiers used for a book amongst various marketplaces
  # and is associated with a given project.  The table stores all know variations of a control number in
  # a single row.  This data is also used to interface with and update similar records in Parse.
  belongs_to :project
end
