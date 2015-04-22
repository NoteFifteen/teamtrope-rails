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

	def import_avatar_from_url url
    # Skip Gravatar URL's
    # We can check Gravatar to see if it's a valid account by passing "?d=404" and checking
    # the response headers for a 200 response.  We may want to either use the Gravatar URL
    # or import the image if it's valid and not just a placeholder.
		if(url =~ /gravatar.com/)
      return false
    end

    self.avatar = download_remote_image(url)
    self.save
  end

  # Stolen from http://stackoverflow.com/questions/1666753/saving-files-using-paperclip-without-upload
  def download_remote_image (image_url)
    io = open(URI.parse(image_url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end

end
