module UsersHelper
  def icon(user, size: 80 )
    if user.twitter_id.blank?
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
      image_tag(gravatar_url, alt: user.name, class: "gravatar")
    else
    end
  end
end
