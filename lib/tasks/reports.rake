namespace :teamtrope do
  desc "Generates the MonthlyPublishedBook records based upon the currenlty published set of books."
  task generate_monthly_published_report: :environment do

    first_published = ProjectGridTableRow.published_books.includes(project: :published_file).joins(project: :published_file).where.not("published_files.publication_date is NULL").order("published_files.publication_date asc").first
    report_date = first_published.publication_date.beginning_of_month

    this_month = Date.today.beginning_of_month

    puts "first date: #{report_date}"
    while report_date <= this_month

      puts "working on : #{report_date}"
      puts "#{report_date}, #{report_date.end_of_month}"
      puts ProjectGridTableRow.published_books.joins(project: :published_file).where("published_files.publication_date >= ? and published_files.publication_date <= ?", report_date, report_date.end_of_month).count

      report_date  += 1.month
    end

  end
end
