class HellosignSignature < ActiveRecord::Base
  belongs_to :hellosign_document
  belongs_to :member, foreign_key: :member_id, class_name: :User
end
