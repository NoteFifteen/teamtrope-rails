class Post < ActiveRecord::Base
	belongs_to :author, class_name: :User
	
	has_many :comments,  dependent: :destroy
	has_many :post_tags, foreign_key: :post_id, dependent: :destroy
	has_many :tags,      through: :post_tags,   source: :tag
	
	default_scope -> { order('created_at DESC') }
	
	validates :author_id, presence: true
end
