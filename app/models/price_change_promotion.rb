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

  # compensate for price change promotions that start and end on the same day
  # by incrementing the end date by 1.day
  before_save {
    unless self.end_date.nil?
      if self.start_date.year == self.end_date.year &&
        self.start_date.month == self.end_date.month &&
        self.start_date.day == self.end_date.day
        self.end_date = self.end_date + 1.day
      end
    end
    true
  }

  # adjust for dst
  before_save {
    self.start_date = adjust_date_for_dst start_date
    self.end_date =  adjust_date_for_dst end_date

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
      # the timezone is utc which never goes on dst so we need to set the zone
      # to the appropriate time zone first and then check if it's dst.
      if date.in_time_zone('Pacific Time (US & Canada)').dst?
        return date - 1.hour
      end
      date
    end

    def destroy_parse_queue_entries
      ParseWorker.create(parse_ids: parse_ids.map{ | key, value | value.split(',') }.flatten , operation: :destroy_parse_queue_entries) unless parse_ids.nil?
    end
end
