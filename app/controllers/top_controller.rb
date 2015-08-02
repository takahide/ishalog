require "open-uri"

class TopController < ApplicationController
  def index
    @s = params[:s]
    @d = params[:d]

    File.open("public/canon_departments.txt", "r") do |file|
      file.each do |line|
        @departments = line.split(",")
      end
    end
  end

  def search 
    @top_link = "/?s=#{params[:s]}&d=#{params[:d]}"
    s = params[:s].split("(")
    station = s[0].strip if s[0].present?
    pf = s[1].strip if s[1].present?
    prefecture = ""

    if pf.present?
      prefectures = Prefecture.all
      prefectures.any? do |p|
        if pf.include? p.name
          prefecture = p.name
        end
      end
    end

    department = params[:d]
    if params[:s].present?
      station = "#{station}駅" if station[-1] != "駅"
    end
    @clinics = Clinic.where(station: station).where("department LIKE ?", "%#{department}%").where("address LIKE ?", "#{prefecture}%")
    if station.present? && department.present?
      @title = "#{station}の#{department}一覧"
    elsif station.present?
      @title = "#{station}の病院一覧"
    elsif department.present?
      @title = "#{department}一覧"
    else
      @title = "病院一覧"
    end

    c = Station.find_by(name: params[:s]).close_stations
    @close_station_clinics = []
    if c.present?
      c.split(",").each do |s|
        s.strip!
        staion = "#{s}駅" if s[-1] != "駅"
        @close_station_clinics.push  Clinic.where(station: station).where("department LIKE ?", "%#{department}%").where("address LIKE ?", "#{prefecture}%") if @close_station_clinics.present?
      end
    end
  end

  def recommendations
    File.open("public/canon_departments.txt", "r") do |file|
      file.each do |line|
        @departments = line.split(",")
      end
    end
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

  def clinic
    id = params[:id]
    @clinic = Clinic.find id
    
    @close_clinics = @clinic.close_clinics
  end

  def login

  end

  def aboutus

  end
end
