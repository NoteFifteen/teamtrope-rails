class AddUserReferenceToHellosignSignature < ActiveRecord::Migration
  def change
    add_reference :hellosign_signatures, :member, foreign_key: :user_id, class_name: :User, index: true
  end
end
