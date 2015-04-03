class HellosignDocument < ActiveRecord::Base
	has_many :hellosign_signatures
	has_many :team_memberships, through: :hellosign_signatures
	
	def HellosignDocument.send_creative_team_agreement(team_membership)
		hellosign_hash = create_team_agreement_hash(team_membership)
		response = HelloSign.send_signature_request_with_template(hellosign_hash)
		
		doc = HellosignDocument.create!( name: 'Creative Team Agreement',
					hellosign_id: response.data['signature_request_id'] )
					
		doc.hellosign_signatures.create!( team_membership_id: team_membership.id )
	end
	
	private
	def HellosignDocument.create_team_agreement_hash(team_membership, mode = Figaro.env.hello_sign_status)
		{
  		# defaults to test_mode unless the mode is 'live'.
  		# which is by default set to an environment variable. 
  		test_mode: (mode == 'live')? false : true,
  		template_id: '3f53b709eaf29f4c19cd498fabdcec906679f671',
  		subject: 'Teamtrope Creative Team Agreement',
  		message: 'Please sign this document using HelloSign. Thank you!',
  		signers: 
  		[
  			{
  				email_address: team_membership.member.email,
  				name: team_membership.member.name,
  				role: 'Client'
  			},
  			{
  				email_address: 'justin.jeffress+ken@booktrope.com',
  				name: 'Ken Shear',
  				role: 'Booktrope-CEO'
  			}
  		],
    	ccs: 
    	[
    		{ email_address: 'justin.jeffress+intake@booktrope.com', role: 'Intake Manager'},
    		{ email_address: 'justin.jeffress+hr@booktrope.com', role: 'HR/Accounting'}
    	],
    	custom_fields: 
    	{ 
    		role: team_membership.role.name, 
    		role_description: team_membership.role.contract_description, 
    		percentage: team_membership.percentage
    	}
		}
	end
	
end
