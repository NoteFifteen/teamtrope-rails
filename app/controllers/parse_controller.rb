class ParseController < ApplicationController

	# This is a controller that calls the equivalent method in the parse wrapper.
	# This allows us to interact with parse.com via the view through ajax while keeping our
	# keys safe from prying eyes. Parse has a javascript library but our keys would be 
	# exposed to the scary internet so anyone could hijack our keys and run amuck. 
	
	
	# This is a design decision: We always return ok it's up to the api consumer to check 
	# the response for an error. 

	# GET /parse/get_amazon_sales_rank.json 
	# description: Gets the AmazonStats for a book
	# params:
	#		book - the parseId of the book for example pe2oMCIf9b 
	def get_amazon_sales_rank
	
		results = Booktrope::ParseWrapper.get_amazon_sales_rank(params[:book])
		render json: results, status: :ok 
		
	end

	# (Not ending with prepositions is something up with I will not put.) ;)
	# GET /parse/get_sales_data_for_channel
	# description: Gets the [channel*]SalesData for a channel. *supported channels are 
	#  (:amazon, :apple, :nook) refer to app/business/booktrope/parse_wrapper.rb
	# params:
	#		channel - the sales channel to get sales data from
	#   book    - the parseId of the book for example pe2oMCIf9b 
	def get_sales_data_for_channel
	
		results = Booktrope::ParseWrapper.get_sales_data_for_channel(params[:channel].to_sym, params[:book])
		render json: results, status: :ok		
		
	end
			
	# price changer functions
	
	# GET /parse/get_queued_items
	# description: Gets the price change queue entries for a book
	# refer to app/business/booktrope/parse_wrapper.rb
	# params:
	#   book    - the parseId of the book for example pe2oMCIf9b 
	def get_queued_items
		
		results = Booktrope::ParseWrapper.get_queued_items(params[:book])
		render json: results, status: :ok
		
	end

	# GET /parse/add_book_to_price_change_queue
	# description: Adds a price change request to PriceChangeQueue for each channel in SalesChannel 
	# params:
	#		book  - the parseId of the book for example pe2oMCIf9b.
	#		price - the price change the book to.
	#		date  -	the date that the price change will take affect.
	def add_book_to_price_change_queue
		results = Booktrope::ParseWrapper.add_book_to_price_change_queue params[:book], params[:price], params[:date]
		render json: results, status: :ok
	end

end
