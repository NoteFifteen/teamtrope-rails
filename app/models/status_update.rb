class StatusUpdate < ActiveRecord::Base
  belongs_to :project
  
  # If you want to add more INSERT TO THE END OF THE LIST!!!!!!
  # Inserting anywhere else will mess up the type for all existing records.
  # If this gets bigger it might be a good idea to move this to an object and seed it
  # NOTE: the array index starts at 0 and the primary key sequence starts at 1 so you'll
  # need to convert the database 
  TYPES = [
  							['normal',   'We\'re doing fine, just our weekly update'],
  							['question', 'We have a question / we\'re stuck, help!']
  					 ]

	# setters and getters for the type_index column.   							
	def type=(type)
		self.type_index = TYPES.map(&:first).index(type)
	end
	
	def type
		TYPES[type_index].first unless type_index.nil?
	end  							
end
