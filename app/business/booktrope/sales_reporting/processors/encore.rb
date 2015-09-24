module Booktrope
  module SalesReporting
    module Processors
      class Encore < Kindle

        # Try to locate using the encore_asin in control_numbers
        def locate_project(row)

          t = ControlNumber.arel_table

          # I've found some records marked as 'Encore' which were not
          # Encore sales and matched the regular ASIN.
          if ! row.asin.nil?
            result = ControlNumber.where(
                t[:encore_asin].eq(row.asin) .
                    or(t[:asin].eq(row.asin))
            ).first
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