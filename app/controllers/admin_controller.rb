class AdminController < ApplicationController
  before_filter :basic
  def recommendations
    @department_strings = %w(なし 内科 歯科 眼科 耳鼻科 皮膚科 外科 整形外科 泌尿器科 小児科 産婦人科 精神科 総合病院)
    @recommendations = Recommendation.all
    @contacts = Contact.all
    render layout: false
  end

  def departments
    @departments = Department.all.order(:id)
    render layout: "admin"
  end

  def stations
    @hiraganas = %w(あ い う え お か き く け こ さ し す せ そ た ち つ て と な に ぬ ね の は ひ ふ へ ほ ま み む め も や ゆ よ ら り る れ ろ わ)
    @stations = []
    if params[:h].present?
      @stations = Station.where("hiragana like ? or name like ?", "#{params[:h]}%", "#{params[:h]}%")
    end
    render layout: "admin"
  end

  def edit_departments
    d = Department.find params[:id]
    d.canon = params[:canon]
    d.save
    render json: d
  end

  def edit_stations
    s = Station.find params[:id]
    s.close_stations = params[:close_stations]
    s.save
    render json: s
  end

  private
    def basic
      authenticate_or_request_with_http_basic do |user, pass|
        user == ENV["BASIC_USER"] && pass == ENV["BASIC_PASS"]
      end
    end
end
