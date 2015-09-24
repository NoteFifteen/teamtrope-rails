class ReportDataFile < ActiveRecord::Base
  has_many :report_data_rows, dependent: :destroy
end
