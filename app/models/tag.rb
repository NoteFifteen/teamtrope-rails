class Tag < ActiveRecord::Base

	has_many :post_tags, foreign_key: :tag_id, dependent: :destroy
	has_many :posts,     through: :post_tags, source: :post
	
	validates :name, presence: true, uniqueness: { case_sensitive: false }		


  def slug
    name.downcase.gsub(" ", "-")  
  end

	def to_param
		"#{id}-#{slug}"
	end

end
