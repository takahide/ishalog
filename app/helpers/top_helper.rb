module TopHelper
  def fb_pic id
    if @my_recommendations.size >= 1
      "/images/fb_pics/#{id}.jpg"
    else
      @picture
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
