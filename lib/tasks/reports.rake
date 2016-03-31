namespace :teamtrope do
  desc "Generates the MonthlyPublishedBook records based upon the currenlty published set of books."
  task generate_monthly_published_report: :environment do

    MonthlyPublishedBook.generate_monthly_report

  end
end
