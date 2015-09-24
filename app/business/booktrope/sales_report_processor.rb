module Booktrope
  class SalesReportProcessor

    # All of the different Source Processors
    Processors = [
        # All non-specific records
        Booktrope::SalesReporting::Processors::BasicProcessor,

        # Custom processors
        Booktrope::SalesReporting::Processors::CreateSpace,
        Booktrope::SalesReporting::Processors::Encore,
        Booktrope::SalesReporting::Processors::Itunes,
        Booktrope::SalesReporting::Processors::Inscribe,
        Booktrope::SalesReporting::Processors::Kindle,
        Booktrope::SalesReporting::Processors::Kobo,
        Booktrope::SalesReporting::Processors::Lsi,
        Booktrope::SalesReporting::Processors::Nook,
        Booktrope::SalesReporting::Processors::Oyster,
        Booktrope::SalesReporting::Processors::Scribd,
    ]

    # Iterate through a CSV file and add all related records
    def process_report_file(csv_filename)

      raise "Cannot locate #{ENV['report_file']}!" unless File.exist?(csv_filename)

      require 'csv.rb'

      file = ReportDataFile.new
      file.filename = csv_filename
      file.source_file = File.read(file.filename)
      file.save

      CSV.foreach(ENV['report_file'], :headers => :first_row, :header_converters => :symbol, :encoding => 'ISO-8859-1') do | rec |

        # This is debug log so we really only want it if executed from the console
        if File.basename($0) == 'rake'
          puts "#{rec[:source_table_name]} - #{rec[:start_date]} / #{rec[:end_date]} - #{rec[:epub_isbn]}"
        end

        # Skip blank lines or unprocessable files
        continue if rec[:source_table_name].nil?

        # Convert the dates
        start_date = transform_date(rec[:start_date])
        end_date = transform_date(rec[:end_date])

        # This represents one row of the report that's been uploaded, but shouldn't
        # be used as the basis for reporting.  We'll write out monthly & daily aggregates
        # further down.
        row = ReportDataRow.new
        row.report_data_file      = file
        row.source_table_name     = rec[:source_table_name]
        row.start_date            = start_date
        row.end_date              = end_date
        row.country               = rec[:country]
        row.currency_use          = rec[:currency_use]
        row.quantity              = rec[:quantity].to_i
        row.revenue_multiccy      = rec[:revenue_multiccy].to_f

        # This is passed along by some channels, but I don't really trust it
        row.unit_revenue          = rec[:unit_revenue].to_f

        # This should be the total of qty * revenue
        row.revenue_usd           = rec[:revenue_usd].to_f

        row.bn_identifier         = rec[:bn_identifier]
        row.epub_isbn             = rec[:epub_isbn]
        row.paperback_isbn        = rec[:paperback_isbn]
        row.apple_identifier      = rec[:apple_identifier]
        row.asin                  = rec[:asin]
        row.kdp_royalty_type      = rec[:kdp__royalty_type]
        row.kdp_transaction_type  = rec[:kdp__transaction_type]
        row.list_price_multiccy   = rec[:list_price_multiccy].to_f
        row.isbn_hardcover        = rec[:isbn_hardcover_use]

        # These are option fields that may or may not exist depending on the import file
        row.author                = rec[:author] if rec.has_key?(:author)
        row.title                 = rec[:title] if rec.has_key?(:title)
        row.imprint               = rec[:imprint] if rec.has_key?(:imprint)
        row.sale_date             = transform_date(rec[:sale_date]) if rec.has_key?(:sale_date)
        row.retailer              = rec[:retailer] if rec.has_key?(:retailer)
        row.period                = rec[:period] if rec.has_key?(:period)

        row.save

        add_row_to_sales_records(row)

      end

      # Need to iterate through processors and tell them all to save
      Processors.each do |p|
        instance = p.instance
        instance.record_sales_records(file)
      end

    end

    # Factory method to get a processor based on the source of the report
    def get_processor(row)

      # Sane default for now
      processor = Booktrope::SalesReporting::Processors::BasicProcessor.instance

      case row.source_table_name.upcase
        when 'CREATESPACE'
          processor = Booktrope::SalesReporting::Processors::CreateSpace.instance
        when 'ENCORE', 'AMAZON ENCORE'
          processor = Booktrope::SalesReporting::Processors::Encore.instance
        when 'KINDLE', 'KDP'
          processor = Booktrope::SalesReporting::Processors::Kindle.instance
        when 'KOBO'
          processor = Booktrope::SalesReporting::Processors::Kobo.instance
        when 'LSI'
          processor = Booktrope::SalesReporting::Processors::Lsi.instance
        when 'NOOK'
          processor = Booktrope::SalesReporting::Processors::Nook.instance
        when 'OYSTER'
          processor = Booktrope::SalesReporting::Processors::Oyster.instance
        when 'INSCRIBE'
          processor = Booktrope::SalesReporting::Processors::Inscribe.instance
        when 'ITUNES'
          processor = Booktrope::SalesReporting::Processors::Itunes.instance
        when 'SCRIBD'
          processor = Booktrope::SalesReporting::Processors::Scribd.instance

        # All of these just use the basic processor
        when 'AMAZON PUBLISHING AGREEMENT'
        when 'BULK'
        when 'DIRECT SALES'
        when 'EBSCO'
      end

      processor
    end

    private

    # Reformat the timestamp from m/d/y h:mm to Y/m/d for Postgres
    def transform_date(dateStamp)
      if ! dateStamp.nil? && dateStamp.length >= 6
        m = dateStamp.match(/(\d{1,2})\/(\d{1,2})\/(\d{1,2})/)
        if ! m.nil?
           date = Date.parse("20#{m[3]}/#{m[1]}/#{m[2]}")
        else
          date = Date.parse(dateStamp)
        end

        if ! date.nil?
          dateStamp = date.strftime('%Y-%m-%d')
        end
      end

      dateStamp
    end

    # Identify the processor for the record, then add it
    def add_row_to_sales_records(row)
      processor = get_processor(row)
      processor.add_sales_record(row)
    end

  end
end
