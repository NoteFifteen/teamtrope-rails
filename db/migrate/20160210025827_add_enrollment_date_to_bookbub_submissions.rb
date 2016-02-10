class AddEnrollmentDateToBookbubSubmissions < ActiveRecord::Migration
  def change
    add_column :bookbub_submissions, :enrollment_date, :date
  end
end
