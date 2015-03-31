module Booktrope
	class BoxrWrapper
	
		def BoxrWrapper.upload_1099_data(form_data = {})
			result = true
			client = BoxrWrapper.client
			
			# if there was an error creating the client (most likely we have no credentials)
			return nil if client.nil?
						
			temp_file = Tempfile.new(['1099', '.txt'])
			begin
				form_data.each do | key, value |
					temp_file.write("#{key}\t#{value}\n")
				end
				
				temp_file.rewind
				
				folder = client.folder_from_path('/')
				begin
					file = client.upload_file(temp_file, folder)
				rescue	Boxr::BoxrError => error
					result = error
				end
			ensure
				temp_file.close
				temp_file.unlink
			end
			result
		end
	
		private
		def BoxrWrapper.client
			box_credential = BoxCredential.first
			
			return nil unless box_credential
			
			refresh_callback = lambda {| access, refresh, identifier |
				 BoxCredential.create! access_token: access, refresh_token: refresh }
				 
			Boxr::Client.new(box_credential.access_token,
						refresh_token: box_credential.refresh_token,
						&refresh_callback)
		end
		
	end
end