module Booktrope
  module SalesReporting
    module Processors

      # Generic processor for channels which identify using just the epub_isbn
      class EpubIsbn < BasicProcessor

        # Try to locate using the epub ISBN
        def locate_project(row)
          if row.epub_isbn.nil?
            return nil
          end

          t = ControlNumber.arel_table

          result = ControlNumber.where(
              t[:epub_isbn].eq(row.epub_isbn)
          ).first

          if ! result.nil?
            puts "Located project #{result.project.title}"
            return result.project
          end
        end

      end
    end
  end
end