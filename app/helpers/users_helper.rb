module UsersHelper
  def icon(user, size: 80)
    if user.icon.present?
      image_tag(user.icon, alt: user.name, class: "ownicon", size: size)
    else
      dummy = "https://placehold.jp/#{size}.png"
      image_tag(dummy, alt: user.name, class: "ownicon", size: size)
    end
  end
end
