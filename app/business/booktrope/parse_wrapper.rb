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
		
		#def initialize
			#ParseHelper.init_development
		#end
		
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
		
		def ParseWrapper.add_book_to_price_change_queue(book, price, date, isEnd = false, isPriceIncrease = false)
			
			book = prepare_book(book, true)

			ParseWrapper.request do 
				sales_channels = Parse::Query.new("SalesChannel").get.each do | channel |
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
					queue_entry["isEnd"] = isEnd
					queue_entry["isPriceIncrease"] = isPriceIncrease
				
					queue_entry.save
				end
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