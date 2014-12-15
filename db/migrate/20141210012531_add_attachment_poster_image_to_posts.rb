class AddAttachmentPosterImageToPosts < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.attachment :poster_image
    end
  end

  def self.down
    remove_attachment :posts, :poster_image
  end
end
