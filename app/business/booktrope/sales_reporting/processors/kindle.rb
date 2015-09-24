module Booktrope
  module SalesReporting
    module Processors
      class Kindle < BasicProcessor

        # Include another aggregator if it's generic (monthly, daily)

        # Try to locate using the asin, epub_isbn, need kdp_transaction_type & kdp_royalty_type
        def locate_project(row)

          t = ControlNumber.arel_table

          ## We want to avoid querying for a null value because it will definitely match
          if ! row.asin.nil? && ! row.epub_isbn.nil?
            result = ControlNumber.where(
                t[:asin].eq(row.asin) .
                    or(t[:epub_isbn].eq(row.epub_isbn))
            ).first
          else
            if ! row.asin.nil?
              result = ControlNumber.where(
                  t[:asin].eq(row.asin)
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

        # Overridden method just for Kindle because we need to separate kdp_transaction and kdp_royalty_types
        def add_row_to_records(row, project_id)
          # Initialize
          @records = {} unless ! @records.nil?

          # If there's no date, we can't do anything with it
          return if row.start_date.nil?

          source = row.source_table_name
          country = normalize_country(row.country, row.currency_use)

          year = row.start_date.year
          month = row.start_date.month

          list_price = row.list_price_multiccy || 0.0

          ## Now the nasty code to search then initialize the aggregator storage
          if ! @records.has_key?(source)
            @records[source] = {}
          end

          if ! @records[source].has_key?(year)
            @records[source][year] = {}
          end

          if ! @records[source][year].has_key?(month)
            @records[source][year][month] = {}
          end

          if ! @records[source][year][month].has_key?(country)
            @records[source][year][month][country] = {}
          end

          if ! @records[source][year][month][country].has_key?(project_id)
            @records[source][year][month][country][project_id] = {}
          end

          if ! @records[source][year][month][country][project_id].has_key?(list_price)
            @records[source][year][month][country][project_id][list_price] = {}
          end

          if ! @records[source][year][month][country][project_id][list_price].has_key?(row.kdp_transaction_type)
            @records[source][year][month][country][project_id][list_price][row.kdp_transaction_type] = {}
          end

          if ! @records[source][year][month][country][project_id][list_price][row.kdp_transaction_type].has_key?(row.kdp_royalty_type)
            @records[source][year][month][country][project_id][list_price][row.kdp_transaction_type][row.kdp_royalty_type] = []
          end

          @records[source][year][month][country][project_id][list_price][row.kdp_transaction_type][row.kdp_royalty_type] << row
        end

        # This will record all records passed into it into monthly sales records
        def record_sales_records(report_data_file)

          # In case there are no records for this processor
          return if @records.nil?

          @records.each do |source, source_list|
            puts "Recording sales for #{source}"

            source_list.each do |year, year_list|
              year_list.each do |month, month_list|
                month_list.each do |country, country_list|
                  country_list.each do |project_id, list_prices|
                    list_prices.each do |list_price, projects_list|
                      projects_list.each do |kdp_transaction_type, kdp_transactions|
                        kdp_transactions.each do |kdp_royalty_type, records|

                            if (! defined? @monthly_sales) || (@monthly_sales.nil?)
                              @monthly_sales = ReportDataMonthlySales.new
                            end

                            # These are all of records for the project
                            records.each do |row|

                              if ! @monthly_sales.nil? && @monthly_sales.is_valid.nil?
                                @monthly_sales.is_valid = true
                                @monthly_sales.report_data_file = report_data_file
                                @monthly_sales.report_data_source = get_report_data_source_model(source)
                                @monthly_sales.report_data_country = get_report_data_country_model(country) unless country.nil?
                                @monthly_sales.year = year
                                @monthly_sales.month = month
                                @monthly_sales.project_id = project_id unless project_id == 0
                                @monthly_sales.list_price = list_price || 0.0
                                @monthly_sales.report_data_kdp_type = get_report_data_kdp_transaction_type_model(kdp_transaction_type, kdp_royalty_type)
                              end

                              ## Sum the totals here
                              @monthly_sales.quantity += row.quantity unless row.quantity.nil?
                              @monthly_sales.revenue += row.revenue_usd unless row.revenue_usd.nil?

                            end
                            # save the record after we've totaled everything up, then reset
                            @monthly_sales.save
                            @monthly_sales = nil

                        end
                      end
                    end
                  end
                end
              end
            end
          end
          # End of @records loop

        end

        # Fetch the reference data for the KDP Transaction/Royalty Type Combo
        def get_report_data_kdp_transaction_type_model(transaction_type, royalty_type)
          ReportDataKdpType.where(
                           kdp_transaction_type: transaction_type,
                           kdp_royalty_type: royalty_type
          ).first_or_create
        end

      end
    end
  end
end