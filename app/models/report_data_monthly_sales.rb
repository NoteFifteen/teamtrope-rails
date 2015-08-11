class ReportDataMonthlySales < ActiveRecord::Base
  belongs_to :report_data_file
  belongs_to :report_data_source
  belongs_to :report_data_country
  belongs_to :report_data_kdp_type
  belongs_to :project
end

