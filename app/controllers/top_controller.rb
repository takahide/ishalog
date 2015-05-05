class TopController < ApplicationController
  def index
    if current_user.present?
      token = current_user.token
      @graph = Koala::Facebook::API.new(token)
      @token = @graph.get_picture('me')
    else 
      @token = nil
    end
  end
end
