module TopHelper
  def is_new
    if @my_recommendations.size < 1
      "new"
    else
      "not_new"
    end
  end
  def random_pic uid
    if uid[0].to_i % 2 == 0
      "man.png"
    else
      "woman.png"
    end
  end

  def fb_pic uid
    if @my_recommendations.size >= 1
      "/images/fb_pics/#{uid}.jpg"
    else
      self.random_pic uid
    end
  end

  def friend_name uid
    if @my_recommendations.size < 1
      return ""
    end
    @friends.each do |f|
      if f["id"] == uid
        return "（#{f["name"]}）"
      end
    end
  end
end
