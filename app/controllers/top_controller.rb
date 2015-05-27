require "open-uri"

class TopController < ApplicationController
  def index
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
      friends = @graph.get_connections('me', 'friends', :local => 'ja-jp')
      friend_ids = []
      friends.each do |friend|
        friend_ids.push friend['name']
      end
      @friends = friend_ids
      @my_recommendations = Recommendation.where(uid: uid).order(updated_at: :desc).limit(100)
    else 
      redirect_to "/login"
    end
  end

  def login

  end

  def test
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
      friends = @graph.get_connections('me', 'friends', :local => 'ja-jp')
      friend_ids = []
      friends.each do |friend|
        friend_ids.push friend['id']
      end
      @friends_recommendations = Recommendation.where("uid IN (?)", friend_ids).order(updated_at: :desc).limit(100)
      friend_ids.push current_user.uid
      @others_recommendations = Recommendation.where("uid NOT IN (?)", friend_ids).order(updated_at: :desc).limit(100)
      @my_recommendations = Recommendation.where(uid: uid).order(updated_at: :desc).limit(100)
    else 
      redirect_to "/login"
    end
  end
end
