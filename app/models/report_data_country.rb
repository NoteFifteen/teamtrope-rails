class ReportDataCountry < ActiveRecord::Base
  has_many :report_data_monthly_sales
end
