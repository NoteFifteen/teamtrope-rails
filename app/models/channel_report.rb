class ChannelReport < ActiveRecord::Base
  has_many :channel_report_items, dependent: :destroy

  attr_accessor :report_hash

  def initialize(**options)
    super(options)
    @report_hash = {}
  end

  def report_items_by_title
    channel_report_items.order("title ASC")
  end

  def insert_book(book)
    @report_hash[book['objectId']] = channel_report_items.create(
      parse_id: book['objectId'],
      title:       book['title'],
      amazon_link: book['detail_url'],
      apple_link:  book['detailUrlApple'],
      nook_link:   book['detailPageUrlNook'],
      kdp_select: false,
      amazon: false,
      apple: false,
      nook: false,
     )
  end

  def insert_books(book_list)
    book_list.each do | book |
      insert_book(book)
    end
  end

  def mark_kdp_books(kdp_books)
    kdp_books.each do | kdp_book |
      next if kdp_book.control_number.nil?
      if @report_hash.has_key? kdp_book.control_number.parse_id
        report_item = @report_hash[kdp_book.control_number.parse_id]
        report_item.update_attributes(kdp_select: true)
      end
    end
  end

  def mark_books_for_sale_on_channel(result_hash, channel)
    result_hash.each do | key, book_wrapper |
      if @report_hash.has_key? book_wrapper[:book]['objectId']
        report_item = @report_hash[book_wrapper[:book]['objectId']]
        case channel
        when :amazon
          report_item.update_attributes(amazon: book_wrapper[:status])
        when :apple
          report_item.update_attributes(apple: book_wrapper[:status])
        when :nook
          report_item.update_attributes(nook: book_wrapper[:status], nook_link: book_wrapper[:location])
        end
      end
    end
  end

end
