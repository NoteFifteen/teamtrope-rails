class ReportDataRow < ActiveRecord::Base
  belongs_to :report_data_file
  has_one  :project

end
