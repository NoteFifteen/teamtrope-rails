module Booktrope
  module SalesReporting
    module Processors
      class Itunes < BasicProcessor

        # Try to locate using the apple_identifier or epub_isbn
        def locate_project(row)

          t = ControlNumber.arel_table

          ## We want to avoid querying for a null value because it will definitely match
          if ! row.apple_identifier.nil? && ! row.epub_isbn.nil?
            result = ControlNumber.where(
                t[:apple_id].eq(row.apple_identifier) .
                    or(t[:epub_isbn].eq(row.epub_isbn))
            ).first
          else
            if ! row.apple_identifier.nil?
              result = ControlNumber.where(
                  t[:apple_id].eq(row.apple_identifier)
              ).first
            end

            if ! row.epub_isbn.nil?
              result = ControlNumber.where(
                  (t[:epub_isbn].eq(row.epub_isbn))
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