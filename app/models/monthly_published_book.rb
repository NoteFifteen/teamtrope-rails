class MonthlyPublishedBook < ActiveRecord::Base
  def self.csv_export
    require 'csv'
    csv_string = CSV.generate do | csv |
    end
  end
end
