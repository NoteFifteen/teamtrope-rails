class PostTag < ActiveRecord::Base
	belongs_to :post, class_name: :Post
	belongs_to :tag,  class_name: :Tag

	validates :post_id, presence: true
	validates :tag_id,  presence: true
end
