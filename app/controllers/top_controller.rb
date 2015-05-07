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
        @recommendations = Recommendation.where uid: friend['id']
      end
    else 
      @token = nil
      @friends = []
    end
  end

end
