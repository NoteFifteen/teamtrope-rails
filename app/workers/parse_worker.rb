class ParseWorker
  include Resque::Plugins::Status
  @queue = :parse_queue

  def perform
    object_id = options["object_id"]
    operation = options["operation"].to_sym
    case operation
    when :control_number
      Booktrope::ParseWrapper.update_project_control_numbers ControlNumber.find(object_id)
    when :destroy_parse_queue_entries
      parse_ids = options["parse_ids"]
      Booktrope::ParseWrapper.destroy_price_queue_entries(parse_ids) unless parse_ids.nil?
    when :price_change_promotion
      Booktrope::ParseWrapper.push_or_edit_queue_entries_to_parse object_id
    else
      puts "Unsupported Operation Code"
    end
  end
end
