class PriceChangePromotion < ActiveRecord::Base

  belongs_to :project

  TYPES = %w[temporary_force_free temporary_price_drop permanent_force_free permanent_price_drop]

  before_destroy :destroy_parse_queue_entries

  PROMOTION_TYPES = [
      [ 'temporary_force_free', 'Temporary iTunes/Force free' ],
      [ 'temporary_price_drop', 'Temporary Price promotion' ],
      [ 'permanent_force_free', 'Permanent iTunes/Force free' ],
      [ 'permanent_price_drop', 'Permanent or Indefinite Time* Price change' ]
  ]

  SITES =
  [
    ['midlist', 'The Midlist (Only submit for Free Feature, not the $100 ad) - https://www.themidlist.com/submit'],
    ['bargain_booksy', 'Bargain Booksy (only submit for free editorial consideration, not the $50 guarantee) - http://bargainbooksy.com/for-authors/']
  ]

  SITES_LIST = SITES.to_h.keys

  before_save {
    self.start_date = adjust_date_for_dst start_date
    self.end_date =  adjust_date_for_dst end_date

    true
  }

  before_save {

    if ! project.control_number.nil?

      queue = []

      case type.first
      when "temporary_force_free"
        queue.push([0, start_date.to_datetime, force_free: true])
        queue.push([price_after_promotion, end_date.to_datetime, force_free: true, is_end: true, is_price_increase: true])
      when "temporary_price_drop"
        queue.push([price_promotion, start_date.to_datetime])
        queue.push([price_after_promotion, end_date.to_datetime, is_end: true, is_price_increase: true])
      when "permanent_force_free"
        queue.push([0, start_date.to_datetime, force_free: true])
      when "permanent_price_drop"
        queue.push([price_promotion, start_date.to_datetime])
      end

      is_new = (self.parse_ids).nil?? true  : false

      queue.each do | price_change |
        book = project.control_number.parse_id

        parse_keys = nil

        if !is_new && !self.parse_ids.nil?

          key = "start_ids"
          if (price_change.last.class == Hash) && price_change.last[:is_end]
            key = "end_ids"
          end
          parse_keys = self.parse_ids[key].split(',')
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
        parse_id_hash = Booktrope::ParseWrapper::add_book_to_price_change_queue(book, *price_change)

        if is_new
          unless self.parse_ids.nil?
            self.parse_ids.merge! parse_id_hash
          else
            self.parse_ids = parse_id_hash
          end
        end
      end
    end

    true
  }

  def project
    Project.find project_id
  end

  def type=(type)
    self.type_mask = ([type] & TYPES).map { |t| 2**TYPES.index(t) }.sum
  end

  def type
    TYPES.reject { |t| ((type_mask || 0) & 2**TYPES.index(t)).zero? }
  end

  def sites=(sites)
    self.sites_mask = (sites & SITES_LIST).map { |t| 2**SITES_LIST.index(t) }.sum
  end

  def sites
    SITES_LIST.reject { |t| ((sites_mask || 0) & 2**SITES_LIST.index(t)).zero? }
  end

  private
    def adjust_date_for_dst(date)
      if date.to_time.dst?
        return date - 1.hour
      end
      date
    end

    def destroy_parse_queue_entries
      Booktrope::ParseWrapper.destroy_price_queue_entries(
                parse_ids.map{ | key, value | value.split(',') }.flatten ) unless parse_ids.nil?
    end
end
