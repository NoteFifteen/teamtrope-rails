module Booktrope
  module SalesReporting
    module Processors

      # Generic processor for channels which identify using either the Paperback or Hardback ISBNs
      class PaperbackHardbackIsbn < BasicProcessor

        # Try to locate using the Paperback ISBN, and if that fails try the Hardback ISBN
        def locate_project(row)
          t = ControlNumber.arel_table

          ## We want to avoid querying for a null value because it will definitely match
          if ! row.paperback_isbn.nil? && ! row.isbn_hardcover.nil?
            result = ControlNumber.where(
                t[:paperback_isbn].eq(row.paperback_isbn) .
                    or(t[:hardback_isbn].eq(row.isbn_hardcover))
            ).first
          else
            if ! row.paperback_isbn.nil?
              result = ControlNumber.where(
                  t[:paperback_isbn].eq(row.paperback_isbn)
              ).first
            end

            if ! row.isbn_hardcover.nil?
              result = ControlNumber.where(
                  (t[:hardback_isbn].eq(row.isbn_hardcover))
              ).first
            end
          end

          if ! result.nil?
            puts "Located project #{result.project.title}"
            return result.project
          end
        end

      end
    end
  end
end