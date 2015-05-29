class RecommendationsController < ApplicationController
  def create
    json = nil
    uid = current_user.uid
    id = params[:id].delete('"').delete("'")
    doctor = params[:doctor].delete('"').delete("'")
    location = params[:location].delete('"').delete("'")
    rating = params[:rating].delete('"').delete("'")
    department = params[:department].delete('"').delete("'")
    comment = params[:comment].delete('"').delete("'")
    if id == "new"
      Recommendation.where(uid: uid, doctor: doctor, location: location).first_or_create do |r|
        r.rating = rating
        r.department = department
        r.comment = comment
        json = r
      end
    else
      r = Recommendation.find(id)
      if r.uid == uid
        r.rating = rating
        r.department = department
        r.comment = comment
        r.doctor = doctor
        r.location = location
        r.save
        json = r
      end
    end
    render json: json
  end
  def doctor
    @name = params[:doctor]
    @location = params[:location]
    doctor = Doctor.where name: @name, location: @location
    if doctor.nil?
      #Googleで取得して、DBへ突っ込む。
    else
      #doctorをそのまま見せる
    end
  end
end

