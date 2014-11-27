class Tag < ActiveRecord::Base

	has_many :post_tags, foreign_key: :tag_id, dependent: :destroy
	has_many :posts,     through: :post_tags, source: :post

end
