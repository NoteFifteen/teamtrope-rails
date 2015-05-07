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
    # We will store a Gravatar URL but only if the user is registered with Gravatar
    # and an actual image exists for them.
		if(url =~ /gravatar.com/)
      require "net/https"
      require "uri"

      base_url = url.match(/(https:\/\/secure.gravatar.com\/avatar\/\w*)/).captures
      avatar_url = base_url[0]
      url = avatar_url + "?d=404"

      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)

      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      # If we get a 200 response back from Gravatar, store the URL
      if response.code == '200'
        self.avatar_url = avatar_url
        self.save
      end

      return
    end

    # Store a reference to the URL so we can check to see if it's changed in the future
    self.avatar_url = url
    self.avatar = download_remote_image(url)
    self.save
  end

  private

  # Stolen from http://stackoverflow.com/questions/1666753/saving-files-using-paperclip-without-upload
  def download_remote_image (image_url)
    io = open(URI.parse(image_url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end

end
