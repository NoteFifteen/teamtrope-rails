class MonthlyPublishedBook < ActiveRecord::Base

  def self.generate_monthly_report
    # get the first published book in the history of booktrope
    first_published = ProjectGridTableRow.published_books.includes(project: :published_file).joins(project: :published_file).where.not("published_files.publication_date is NULL").order("published_files.publication_date asc").first

    # get the first day of month
    report_date = first_published.publication_date.beginning_of_month

    # get the first day of the current month
    this_month = Date.today.beginning_of_month
    total = 0

    # looping from the first month that we published a book up until the present month
    while report_date <= this_month

      # get the books for the current report_date
      monthly_books = ProjectGridTableRow.published_books
        .joins(project: :published_file)
        .where(
          "published_files.publication_date >= ? and published_files.publication_date <= ?",
          report_date,
          report_date.end_of_month
        )
      monthly_total = monthly_books.count
      total += monthly_total

      monthly_published_book = MonthlyPublishedBook.where(
        report_date: report_date,
      ).first_or_create

      monthly_published_book.update_attributes(
        published_monthly: monthly_total,
        published_total: total,
        published_books: monthly_books.sort{ | a, b | a.title <=> b.title }.map{ | pgtr | { id: pgtr.project.id, title: pgtr.title } }
      )

      # update our iterator
      report_date += 1.month
    end    
  end

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
