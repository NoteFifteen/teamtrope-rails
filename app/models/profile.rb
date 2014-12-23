class Profile < ActiveRecord::Base
  belongs_to :user, foreign_key: :user_id
  
  has_attached_file :avatar,
		:styles => { :large => "600x600>", :medium => "300x300>", :thumb => "100x100>"},
		:convert_options => { :large => "-quality 100", :medium => '-quality 100', :thumb => '-quality 100' },
		:default_url => "/images/:style/missing.gif",
		:processors => [:cropper]
		
		
	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h		
  
  
  def cropping?
		!crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
	end
  
  def avatar_geometry(style = :original)
		@geometry ||= {}
		@geometry[style] ||= Paperclip::Geometry.from_file(avatar.path(style))
	end
  
end
