module ProfilesHelper

  def avatar_url user, image_tag_dimensions, gravatar_size
    avatar_url = nil

    # If don't have an avatar present, try Gravatar
    if !user.profile.avatar.present?
      if !user.profile.avatar_url.nil?
        if user.profile.avatar_url =~ /gravatar.com/
          avatar_url = user.profile.avatar_url + "s=#{gravatar_size}"
        else
          avatar_url = user.profile.avatar_url
        end
      end
    end

    if avatar_url.nil?
      avatar_url = user.profile.avatar.url(image_tag_dimensions)
    end

      avatar_url
  end

  def gravatar_url user, gravatar_size = 150
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    #d=wavatar&
    "https://secure.gravatar.com/avatar/#{gravatar_id}.png?s=#{gravatar_size}"
  end
end
