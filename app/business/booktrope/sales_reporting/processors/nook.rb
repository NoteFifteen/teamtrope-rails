module Booktrope
  module SalesReporting
    module Processors
      class Nook < BasicProcessor

        # Include another aggregator if it's generic (monthly, daily)

        # Try to locate using the Paperback ISBN, and if that fails the Hardback ISBN
        def locate_project(row)

          if row.bn_identifier.nil?
            return nil
          end

          project = Project.joins('INNER JOIN control_numbers ON control_numbers.project_id = projects.id') .
                           joins('INNER JOIN parse_books ON parse_books.epub_isbn = control_numbers.epub_isbn') .
                           joins('INNER JOIN report_data_rows ON report_data_rows.bn_identifier = parse_books.bnid') .
                           where('report_data_rows.id = ?', row.id).first

          if ! project.nil?
            puts "Located project #{project.title}"
            return project
          end

        end

      end
    end
  end
end