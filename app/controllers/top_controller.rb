class TopController < ApplicationController
  def index
    token = current_user.token
    @graph = Koala::Facebook::API.new(token)
    @token = @graph.get_picture('me')
  end
end
