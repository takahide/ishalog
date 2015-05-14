class RecommendationsController < ApplicationController
  def index
  end
  def create
    json = nil
    uid = current_user.uid
    Recommendation.where(uid: uid, doctor: params[:doctor], location: params[:location]).first_or_create do |r|
      r.rating = params[:rating]
      r.department = params[:department]
      r.comment = params[:comment]
      json = r
    end
    render json: json
  end
  def guest_params
    params.require(:recommendation).permit(:doctor, :location, :rating, :department, :comment)
  end
end

