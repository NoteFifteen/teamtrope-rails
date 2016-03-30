class MonthlyPublishedBook < ActiveRecord::Base
  def self.csv_export
    require 'csv'
    csv_string = CSV.generate do | csv |
      csv << [ "Year", "Month", "Number Published", "Total Published" ]

      all.order(report_date: :desc).each do | monthly_published_book |
        csv << [ monthly_published_book.report_date.strftime("%Y"),
          monthly_published_book.report_date.strftime("%m"),
          monthly_published_book.published_monthly,
          monthly_published_book.published_total
        ]
      end

    end
  end
end
