require "open-uri"

class TopController < ApplicationController
  def index
  end

  def search 
    station = params[:s]
    department = params[:d]
    department = "耳鼻いんこう科" if department == "耳鼻科"
    if params[:s].blank?
      station = ""
      redirect_to "/"
    end

    station = "#{station}駅" if station[-1] != "駅"
    @clinics = Clinic.where(station: station).where("department LIKE ?", "%#{department}%")
  end

  def recommendations
    if current_user.present?
      token = current_user.token
      uid = current_user.uid
      @graph = Koala::Facebook::API.new(token)
      if File.exist?("#{Rails.root}/public/images/fb_pics/#{uid}.jpg")
        @picture = "/images/fb_pics/#{uid}.jpg"
      else
        @picture = "https://graph.facebook.com/#{uid}/picture"
        file_name = "#{uid}.jpg"
        file_path = "#{Rails.root}/public/images/fb_pics/#{file_name}"
        open file_path, 'wb' do |output|
          open @picture do |data|
            output.write data.read
          end
        end
      end
      @friends = @graph.get_connections('me', 'friends', :local => 'ja-jp', :limit => 1000)
      friend_ids = []
      @friends.each do |friend|
        friend_ids.push friend['id']
      end
      @friends_recommendations = Recommendation.where("uid IN (?) AND department > 0", friend_ids).order(updated_at: :desc)
      friend_ids.push uid
      @others_recommendations = Recommendation.where("uid NOT IN (?) AND department > 0", friend_ids).order(updated_at: :desc)

      if params[:rec].present?
        @friends_recommendations.each do |r|
          if params[:rec].to_i == r.id
            @featured_recommendation = r
          end
        end
        @others_recommendations.each do |r|
          if params[:rec].to_i == r.id
            @featured_recommendation = r
          end
        end
      end

      @my_recommendations = Recommendation.where("uid IN (?) AND department > 0", uid).order(updated_at: :desc).limit(100)
    else 
      redirect_to "/login"
    end

  end

  def login

  end

  def aboutus

  end
end
