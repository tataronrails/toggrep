module UsersHelper
  def gravatar_for(user)
    size = 90
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=mm"
    image_tag(gravatar_url, class: "circular ui image")
  end
end