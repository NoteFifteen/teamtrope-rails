class HellosignSignature < ActiveRecord::Base
  belongs_to :hellosign_document
  belongs_to :team_membership
end
