class ParseWorker
  include Resque::Plugins::Status
  @queue = :parse_queue

  def perform
    object_id = options["object_id"]
    operation = options["operation"].to_sym
    case operation
    when :control_number
      Booktrope::ParseWrapper.update_project_control_numbers ControlNumber.find(object_id)
    when :team_revenue_allocation
      Booktrope::ParseWrapper.save_revenue_allocation_record_to_parse Project.find(object_id), User.find(options["current_user"]), DateTime.parse(options["effective_date"])
    when :destroy_parse_queue_entries
      parse_ids = options["parse_ids"]
      Booktrope::ParseWrapper.destroy_price_queue_entries(parse_ids) unless parse_ids.nil?
    when :price_change_promotion
      push_or_edit_queue_entries_to_parse object_id
    else
      puts "Unsupported Operation Code"
    end
  end

  def push_or_edit_queue_entries_to_parse(object_id)
    queue = []

    pcp = PriceChangePromotion.find(object_id)
    case pcp.type.first
    when "temporary_force_free"
      queue.push([0, pcp.start_date.to_datetime, force_free: true])
      queue.push([pcp.price_after_promotion, pcp.end_date.to_datetime, force_free: true, is_end: true, is_price_increase: true])
    when "temporary_price_drop"
      queue.push([pcp.price_promotion, pcp.start_date.to_datetime])
      queue.push([pcp.price_after_promotion, pcp.end_date.to_datetime, is_end: true, is_price_increase: true])
    when "permanent_force_free"
      queue.push([0, pcp.start_date.to_datetime, force_free: true])
    when "permanent_price_drop"
      queue.push([pcp.price_promotion, pcp.start_date.to_datetime])
    end

    is_new = (pcp.parse_ids).nil?? true  : false

    queue.each do | price_change |
      book = pcp.project.control_number.parse_id

      parse_keys = nil

      if !is_new && !pcp.parse_ids.nil?

        key = "start_ids"
        if (price_change.last.class == Hash) && price_change.last[:is_end]
          key = "end_ids"
        end
        parse_keys = pcp.parse_ids[key].split(',')
      end

      #TODO: look into moving this outside of the loop and putting into the case above.
      # at that point we already know if is_end is true so there's no need to figure out
      # which hash, we also already know if have parse_ids.
      if price_change.last.class == Hash
        price_change.last[:parse_keys] = parse_keys
      elsif !is_new
        price_change.push({ parse_keys: parse_keys })
      end

      # using the splat operator decomposes the array into the params list
      # https://codequizzes.wordpress.com/2013/09/29/rubys-splat-operator/
      parse_id_hash = add_book_to_price_change_queue(book, *price_change)

      if is_new
        unless pcp.parse_ids.nil?
          pcp.parse_ids.merge! parse_id_hash
        else
          pcp.parse_ids = parse_id_hash
        end
      end
    end
    pcp.save
  end

  def add_book_to_price_change_queue(book, price, date, **options)
    default_options =
    {
      is_end: false,
      is_price_increase: false,
      force_free: false,
      parse_keys: nil
    }

    options = default_options.merge(options)

    book = Booktrope::ParseWrapper.prepare_book(book, true)
    if options[:parse_keys].nil?
      create_price_queue_entries(book, price, date, options)
    else
      update_price_queue_entries(book, price, date, options)
    end
  end

  def create_price_queue_entries(book, price, date, **options)
    queue_entry_ids = []
    Booktrope::ParseWrapper.request do
      sales_chanels = Parse::Query.new("SalesChannel").get
      puts "sales chanels #{sales_chanels.count}"
      at(0, sales_chanels.count, "0 of #{sales_chanels.count}")
      sales_chanels.each_with_index do | channel, index |
        at(index + 1, sales_chanels.count, "#{index + 1} of #{sales_chanels.count}")
        next if options[:force_free] && !channel["canForceFree"] # only if channel allows it.

        queue_entry = Parse::Object.new(Booktrope::ParseWrapper::PriceChangeQueue)
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

  def update_price_queue_entries(book, price, date, **options)
    options[:parse_keys].each do | parse_key |
      Booktrope::ParseWrapper.request do
        queue_entry = Parse::Query.new(Booktrope::ParseWrapper::PriceChangeQueue).eq("objectId", parse_key).get.first

        queue_entry["title"] = book["title"]
        queue_entry["price"] = price.to_f
        queue_entry["status"] = 0
        queue_entry["changeDate"] = Parse::Date.new(date)
        queue_entry["isEnd"] = options[:is_end]

        queue_entry.save
      end
    end
    { (options[:is_end]) ? :end_ids : :start_ids => options[:parse_keys].join(',') }
  end

  def destroy_price_queue_entries(entries)
    entries.each do | entry |
      Booktrope::ParseWrapper.request do
        queue_entry = Parse::Query.new(PriceChangeQueue).eq("objectId", entry).get.first
        queue_entry.parse_delete unless queue_entry.nil?
      end
    end
  end

end
