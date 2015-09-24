module Booktrope
  module SalesReporting
    module Processors
      class BasicProcessor

        # Remove this once we're done adding more processors, the make it so this can't be created
        # as an instance
        include Singleton

        @records = {}

        # This will record all records passed into it into monthly sales records
        def record_sales_records(report_data_file)

          # In case there are no records for this processor
          return if @records.nil?

          @records.each do |source, source_list|
            puts "Recording sales for #{source}"

            source_list.each do |year, year_list|
              year_list.each do |month, month_list|
                month_list.each do |country, project_list|
                  project_list.each do |project_id, list_prices|
                    list_prices.each do |list_price, project|

                      if (! defined? @monthly_sales) || (@monthly_sales.nil?)
                        @monthly_sales = ReportDataMonthlySales.new
                      end

                      # These are all of records for the project
                      project.each do |row|

                        if ! @monthly_sales.nil? && @monthly_sales.is_valid.nil?
                          @monthly_sales.is_valid = true
                          @monthly_sales.report_data_file = report_data_file
                          @monthly_sales.report_data_source = get_report_data_source_model(source)
                          @monthly_sales.report_data_country = get_report_data_country_model(country) unless country.nil?
                          @monthly_sales.year = year
                          @monthly_sales.month = month
                          @monthly_sales.project_id = project_id unless project_id == 0
                          @monthly_sales.list_price = list_price || 0.0
                        end

                        ## Sum the totals here
                        @monthly_sales.quantity += row.quantity unless row.quantity.nil?
                        # @monthly_sales.revenue += row.revenue_usd unless row.revenue_usd.nil?
                        revenue = convert_currency(country, row.currency_use, row.start_date, row.revenue_multiccy, row.revenue_usd)
                        @monthly_sales.revenue += revenue unless revenue.nil?

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
          # End of @records loop

        end

        # We're passed a report data row and now we need to associate it and aggregate it if it's daily and not monthly.
        # Each source has its' own processor which will handle this logic
        def add_sales_record(row)

          # We could probably just get the project_id
          project = locate_project(row)

          # If we identified the project, lets update the row and add it to the stack
          if ! project.nil?
            row.project_id = project.id
            row.save
          end

          # We need a value to pass into the collection, so 0 is used as a placeholder
          # but we'll switch back to nil/null before we save it to the monthly sales record
          if ! project.nil?
            project_id = project.id
          else
            project_id = 0
          end

          # Add to our instance variable
          add_row_to_records(row, project_id)

        end


        ##
        ## All things private below
        ##

        private

        # Stub method - Should be defined in the child processor
        def locate_project(row)
          nil
        end

        # Adds the records to the instance variable which holds all collected
        # values until we need to save them.  Amazon will have its' own implementation
        # because we need to differentiate KDP types
        def add_row_to_records(row, project_id)
          # Initialize
          @records = {} unless ! @records.nil?

          # If there's no date, we can't do anything with it
          return if row.start_date.nil?

          source = row.source_table_name
          country = normalize_country(row.country, normalize_currency_type(row.currency_use))

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
            @records[source][year][month][country][project_id][list_price] = []
          end

          @records[source][year][month][country][project_id][list_price] << row

        end

        # Standardize the currency naming convention
        def normalize_currency_type(currency_type)

          # Default to USD if it's not set
          if currency_type.nil? || currency_type.length == 0
            currency_type = 'USD'
          end

          # Uppercase it just in case since we've seen 'usd'
          currency_type.upcase!

          # Normalize the Euro naming convention
          if %w( EURO ).include?(currency_type)
            currency_type = 'EUR'
          end

          currency_type
        end

        # Standardize the country naming convention to the ISO A2 (two letter) abbreviation
        # Will accept 2 and 3 letter codes and the full name and attempt to convert it
        def normalize_country(country, currency_type)

          # Set the country to US if we're using USD for the currency and no country is set
          if ((country.nil? || country.length == 0) && (! currency_type.nil? && currency_type == 'USD'))
            country = 'US'
          end

          return if country.nil?

          country.upcase!

          case country
            when 'AUSTRALIA, COMMONWEALTH OF', 'AUS', 'LS - AUSTRALIA'
              country = 'AU'
            when 'UK', 'LS-UNITED KINGDOM', 'UNITED KINGDOM OF GREAT BRITAIN AND N. IRELAND'
              country = 'GB'
            when 'EUROPE' # Not really a country..
              country = 'EU'
            when "MONGOLIA, MONGOLIAN PEOPLE'S REPUBLIC"
              country = 'MN'
            when 'SINGAPORE, REPUBLIC OF'
              country = 'SG'
            when 'SOUTH AFRICA, REPUBLIC OF'
              country = 'ZA'
            when 'UNITED STATES OF AMERICA', 'LS-UNITED STATES' 'ESTORE', 'USD'
              country = 'US'
          end

          # If it's greater than a two character code, let's look it up and convert it
          if country.length > 2

            # If it's a large value, search for it by full name
            if country.length > 3
              model = ReportDataCountry.where('UPPER(name) = ?', country).first
            end

            # It's a three letter, so try the UN version
            if country.length == 3
              model = ReportDataCountry.where('UPPER(code_un) = ?', country).first
            end

            if ! model.nil?
              country = model.code_iso
            end
          end

          country
        end

        # Attempt to convert currency to USD if not USD, unless the revenue_usd field is already filled
        # country_code - 2 letter abbreviation to help identify currency type
        # currency_type - The reported currency type, used with revenue_multiccy
        # date - The reported date of the sales
        # revenue_multiccy - The reported revenue from the source
        # recorded_revenue - The revenue_multiccy already converted to USD, if it's been pre-converted for us
        def convert_currency(country_code, currency_type, date, revenue_multiccy, recorded_revenue)

          if currency_type.nil? && country_code.upcase == 'US'
            currency_type = 'USD'
          end

          # No need to convert if it's already USD
          if ! currency_type.nil? && currency_type.upcase == 'USD'
            return revenue_multiccy
          end

          # this value is already converted, so if we have it, return it
          if ! recorded_revenue.nil? && recorded_revenue > 0
            return recorded_revenue
          end

          # If we haven't been passed the correct values necessary to convert, raise an exception
          if currency_type.nil? || date.nil? || revenue_multiccy.nil?
            raise 'Currency Type required for currency conversion!' if currency_type.nil?
            raise 'Date required for currency conversion!' if date.nil?
            raise 'Currency amount required for currency conversion!' if revenue_multiccy.nil?
          end

          # This will fix any funny variations of the currency type
          # like EURO -> EUR
          currency_type = normalize_currency_type(currency_type)

          currency_type = currency_type.downcase.to_sym
          date = date.strftime('%Y-%m-%d')

          revenue = revenue_multiccy.in(currency_type, :at => date).to(:usd)
          revenue.round.to_f
        end

        def get_report_data_country_model(country)
          ReportDataCountry.where(code_iso: country).first_or_create
        end

        def get_report_data_source_model(source_name)
          ReportDataSource.where(name: source_name).first_or_create
        end

      end
    end
  end
end