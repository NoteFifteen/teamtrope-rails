module ProfilesHelper

  def avatar_url user, image_tag_dimensions, gravatar_size
    # If don't have an avatar present, try Gravatar
    if(! user.profile.avatar.present?)
      user.profile.avatar.url(image_tag_dimensions)
      # gravatar_url(user, gravatar_size)
    else
      user.profile.avatar.url(image_tag_dimensions)
    end
  end

  def gravatar_url user, gravatar_size = 150
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    #d=wavatar&
    "https://secure.gravatar.com/avatar/#{gravatar_id}.png?s=#{gravatar_size}"
  end
end
