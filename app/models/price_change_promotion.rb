class PriceChangePromotion < ActiveRecord::Base
  belongs_to :project
  
  TYPES = %w[temporary_force_free temporary_price_drop permanent_force_free permanent_price_drop]
  
  before_save {
  	self.start_date = adjust_date_for_dst start_date
  	self.end_date =  adjust_date_for_dst end_date
  	
  	true
  }
    
  before_save {
		
		queue = []
		
		case type
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
		
		queue.each do | price_change |
			# using the splat operator decomposes the array into the params list
			# https://codequizzes.wordpress.com/2013/09/29/rubys-splat-operator/
			book = project.control_number.parse_id
			parse_id_hash = Booktrope::ParseWrapper::add_book_to_price_change_queue(book, *price_change)
			
			unless self.parse_ids.nil?
				self.parse_ids.merge! parse_id_hash
			else
				self.parse_ids = parse_id_hash
			end
			
		end
		
		true
  }
  
  def project
  	Project.find project_id
  end
  
  def type=(type)
  	self.type_mask = ([type] & TYPES).map { |t| 2**TYPES.index(t) }.first
  end
  
  def type
  	TYPES.reject { |t| ((type_mask || 0) & 2**TYPES.index(t)).zero? }.first
  end
  
  private
	  def adjust_date_for_dst(date)
	  	if date.to_time.dst?
	  		return date - 1.hour
	  	end
	  	date
  	end
end
