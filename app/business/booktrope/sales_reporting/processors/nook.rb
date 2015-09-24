module Booktrope
  module SalesReporting
    module Processors
      class Nook < BasicProcessor

        # Include another aggregator if it's generic (monthly, daily)

        # Try to locate using the Paperback ISBN, and if that fails the Hardback ISBN
        def locate_project(row)

          # Try BNID First
          if ! row.bn_identifier.nil?
            project = Project.joins('INNER JOIN control_numbers ON control_numbers.project_id = projects.id') .
                joins('INNER JOIN parse_books ON parse_books.epub_isbn = control_numbers.epub_isbn') .
                where('parse_books.bnid = ?', row.bn_identifier).first
          end

          if project.nil? && ! row.epub_isbn.nil?
            t = ControlNumber.arel_table

            result = ControlNumber.where(
                t[:epub_isbn].eq(row.epub_isbn)
            ).first

            if ! result.nil?
              project = result.project
            end
          end


          if ! project.nil?
            puts "Located project #{project.title}"
            return project
          end

        end

      end
    end
  end
end