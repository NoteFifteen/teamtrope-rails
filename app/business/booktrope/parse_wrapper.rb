module Booktrope
  class ParseWrapper
    require 'parse-ruby-client'

    AmazonSalesData = "AmazonSalesData"
    AppleSalesData = "AppleSalesData"
    NookSalesData = "NookSalesData"

    PriceChangeQueue = "PriceChangeQueue"
    AmazonStats = "AmazonStats"

    #fields differ based on the object.
    ParseTableFields = {
      amazon: { table_name: AmazonSalesData, fields: ["asin", "dailySales", "dailyKdpUnlimited", "forceFree", "netKdpUnlimited", "netSales", "country", "crawlDate"] },
      apple:  { table_name: AppleSalesData,  fields: ["appleId", "dailySales", "country", "crawlDate"] },
      nook:   { table_name: NookSalesData,   fields: ["nookId", "isbn", "dailySales", "country", "crawlDate"]}
    }

    def ParseWrapper.request
      begin
        yield
      rescue RuntimeError, Parse::ParseProtocolError => e
        case e
        when Parse::ParseProtocolError
          { error: e.response["error"], code: e.response["code"] }
        else
          { error: e.message } #TODO: determine error codes
        end
      end
    end

    def ParseWrapper.get_queued_items(book)
      ParseWrapper.request do
        Parse::Query.new(PriceChangeQueue).tap do | q |
          q.eq("book", prepare_book(book)) # ensure convert strings to Parse::Object, use the Parse::Object else raise an exception
          q.order_by = "changeDate"
          q.include = "book,salesChannel"
        end.get
      end
    end

    def ParseWrapper.get_sales_data_for_channel(channel, book)
      ParseWrapper.request do
        Parse::Query.new(table_for_channel(channel)).tap do | q |
          q.eq("book", prepare_book(book))
          q.limit = 1000
          q.order_by = "crawlDate"
        end.get
      end
    end

    def ParseWrapper.get_amazon_sales_rank(book)
      ParseWrapper.request do
        Parse::Query.new(AmazonStats).tap do | q |
          q.eq("book", prepare_book(book))
          q.limit = 1000
          q.order = :descending
          q.order_by = "crawl_date"

        end.get
      end
    end

    def ParseWrapper.save_revenue_allocation_record_to_parse(project, current_user, submitted_date)

      fields = { sentToRjMetrics: false, submittedBy: current_user.id,
                  teamtropeId: project.id }
      project.team_memberships.includes(:role).each do | tm |
        field_name = tm.role.name.gsub(/ /, "")
        field_name = field_name[0].downcase + field_name[1, field_name.length]

        fields[field_name.pluralize] = [] unless ! fields[field_name.pluralize].nil?

        # We're passing the OldTrope ID for the ID so it matches with what we've been sending previously
        fields[field_name.pluralize].push( { 'Id'=> tm.member.uid, 'Pct' => tm.percentage } )
      end

      fields["submittedEffectiveDate"] = Parse::Date.new(submitted_date)

      if submitted_date == Date.today
        if submitted_date.day != 1
          fields["effectiveDate"] = (submitted_date + 1.month) - ( submitted_date.day - 1)
        else
          fields["effectiveDate"] = submitted_date
        end
      elsif Date.today > submitted_date
        fields["effectiveDate"] = ((Date.today + 1.month) - (Date.today.day - 1)).to_s
      else
        fields["effectiveDate"] = (submitted_date) - (submitted_date.day - 1)
      end

      fields["effectiveDate"] = Parse::Date.new(fields["effectiveDate"])

      ParseWrapper.add_team_revenue_allocation(fields)
    end

    def ParseWrapper.add_team_revenue_allocation(fields)

      raise "fields must be a Hash" unless fields.class == Hash

      team_revenue_allocation = Parse::Object.new("TeamRevenueAllocationRails")
      fields.each do | key, value |
        team_revenue_allocation[key] = value
      end
      team_revenue_allocation.save
    end


    def ParseWrapper.add_book_to_price_change_queue(book, price, date, **options)
      default_options =
      {
        is_end: false,
        is_price_increase: false,
        force_free: false,
        parse_keys: nil
      }

      options = default_options.merge(options)

      book = prepare_book(book, true)
      if options[:parse_keys].nil?
        ParseWrapper.create_price_queue_entries(book, price, date, options)
      else
        ParseWrapper.update_price_queue_entries(book, price, date, options)
      end
    end

    def ParseWrapper.destroy_price_queue_entries(entries)
      entries.each do | entry |
        ParseWrapper.request do
          queue_entry = Parse::Query.new(PriceChangeQueue).eq("objectId", entry).get.first
          queue_entry.parse_delete unless queue_entry.nil?
        end

      end
    end

    def ParseWrapper.update_price_queue_entries(book, price, date, **options)
      options[:parse_keys].each do | parse_key |
        ParseWrapper.request do
          queue_entry = Parse::Query.new(PriceChangeQueue).eq("objectId", parse_key).get.first

          queue_entry["title"] = book["title"]
          queue_entry["price"] = price.to_f

          queue_entry["changeDate"] = Parse::Date.new(date)
          queue_entry["isEnd"] = options[:is_end]

          queue_entry.save
        end
      end
      { (options[:is_end]) ? :end_ids : :start_ids => options[:parse_keys].join(',') }
    end


    def ParseWrapper.create_price_queue_entries(book, price, date, **options)
      queue_entry_ids = []
      ParseWrapper.request do
        sales_channels = Parse::Query.new("SalesChannel").get.each do | channel |

          next if options[:force_free] && !channel["canForceFree"] # only if channel allows it.

          queue_entry = Parse::Object.new(PriceChangeQueue)
          queue_entry["book"] = book
          queue_entry["asin"] = book["asin"]
          queue_entry["title"] = book["title"]

          queue_entry["country"] = "US"

          queue_entry["salesChannel"] = channel
          queue_entry["channelName"] = channel["name"]

          queue_entry["price"] = price.to_f
          queue_entry["status"] = 0
          queue_entry["changeDate"] = Parse::Date.new(date)
          queue_entry["isEnd"] = options[:is_end]
          queue_entry["isPriceIncrease"] = options[:is_price_increase]

          queue_entry.save
          queue_entry_ids.push queue_entry["objectId"]
        end
      end
      { (options[:is_end]) ? :end_ids : :start_ids => queue_entry_ids.join(',') }
    end

    # Accepts a ControlNumber model and creates or updates the equivalent
    # record in Parse.
    def ParseWrapper.update_project_control_numbers(control_number)

      unless control_number.parse_id.try(:empty?)
        # In order to edit an existing record on parse we must load it
        # so we pass true to prepare_book to fetch the record out of parse.
        book = prepare_book(control_number.parse_id, true)
      else
        book = Parse::Object.new("Book")
      end


      # Iterate through the Model's attributes and send
      # over the ones that are populated.
      control_number.attributes.each do |key, value|
        next if value.blank?

        case key
          when 'project_id'
            book["teamtropeProjectId"] = value
          when 'asin'
            book["asin"] = value
          when 'apple_id'
            book["appleId"] = value
          when 'hardback_isbn'
            book["hardbackIsbn"] = value
          when 'paperback_isbn'
            book["paperbackIsbn"] = value
            book["createspaceIsbn"] = value.gsub(/-/, '')
            book["lightningSource"] = value.gsub(/-/, '')
          when 'epub_isbn'
            book["epubIsbn"] = value
            book["epubIsbnItunes"] = value.gsub(/-/, '')

          # This could be the "Publisher" field, but there are a lot of variances
          #when 'imprint'

          # There is no equivalent field for this value in the Book object
          #when 'ebook_library_price'
        end
      end

      # Save the object in Parse
      book.save

      # Update the control_number record if possible
      if(control_number.parse_id.blank? || control_number.parse_id != book['objectId'])
        control_number.parse_id = book['objectId'];
        control_number.save
      end
    end

    private
    def ParseWrapper.prepare_book(book, load = false)
      case book
      when String
        parse_object_id = book
        book = Parse::Object.new("Book")
        book["objectId"] = parse_object_id

      when Parse::Object
        raise "Must be a parse `Book` object received `#{book.class_name}`" unless book.class_name == "Book"
      else
        raise "book must be either a string or a Parse::Object"
      end

      !load ? book :  ParseWrapper.request { Parse::Query.new("Book").tap { | q | q.eq("objectId", book["objectId"]) }.get.first }
    end

    def ParseWrapper.table_for_channel(channel)
      case channel
      when :amazon
        AmazonSalesData
      when :apple
        AppleSalesData
      when :nook
        NookSalesData
      else
        raise "sorry channel: #{channel} is not supported"
      end
    end

  end
end
