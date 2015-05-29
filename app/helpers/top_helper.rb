module TopHelper
  def fb_pic id
    if @my_recommendations.size >= 1
      "/images/fb_pics/#{id}.jpg"
    else
      @picture
    end
  end
end
