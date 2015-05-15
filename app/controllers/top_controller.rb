class TopController < ApplicationController
  def index
    if current_user.present?
      token = current_user.token
      @uid = current_user.uid
      @graph = Koala::Facebook::API.new(token)
      @picture = @graph.get_picture('me')
      friends = @graph.get_connections('me', 'friends', :local => 'ja-jp')
      @friends = []
      friends.each do |friend|
        @friends.push friend['name']
      end
      @my_recommendations = Recommendation.where(uid: @uid).order(updated_at: :desc).limit(100)
    else 
      redirect_to "/login"
    end
  end

  def login

  end
end
