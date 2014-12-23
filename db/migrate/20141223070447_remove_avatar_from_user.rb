class RemoveAvatarFromUser < ActiveRecord::Migration
  def self.up
		remove_attachment :users, :avatar
  end

  def self.down
    change_table :users do |t|
      t.attachment :avatar
    end
  end
end
