class TopController < ApplicationController
  def index
    if current_user.present?
      token = current_user.token
      @uid = current_user.uid
      @graph = Koala::Facebook::API.new(token)
      @picture = @graph.get_picture('me')
      friends = @graph.get_connections('me', 'friends', :local => 'ja-jp')
      friend_ids = []
      friends.each do |friend|
        friend_ids.push friend['name']
      end
      @friends = friend_ids
      @my_recommendations = Recommendation.where(uid: @uid).order(updated_at: :desc).limit(100)
    else 
      redirect_to "/login"
    end
  end

  def login

  end

  def test
    if current_user.present?
      token = current_user.token
      @uid = current_user.uid
      @graph = Koala::Facebook::API.new(token)
      @picture = @graph.get_picture('me')
      friends = @graph.get_connections('me', 'friends', :local => 'ja-jp')
      friend_ids = []
      friends.each do |friend|
        friend_ids.push friend['id']
      end
      @friends_recommendations = Recommendation.where("uid IN (?)", friend_ids).order(updated_at: :desc).limit(100)
      @my_recommendations = Recommendation.where(uid: @uid).order(updated_at: :desc).limit(100)
    else 
      redirect_to "/login"
    end
  end
end
