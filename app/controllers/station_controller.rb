class StationController < ApplicationController
  def show
    @first = params[:first]
    if @first.present?
      s = @first
      stations = Station.where("hiragana like ?", "#{s}%")
      @stations = stations.page(params[:page])
    else 
      @hiraganas = %w(あ い う え お か き く け こ さ し す せ そ た ち つ て と な に ぬ ね の は ひ ふ へ ほ ま み む め も や ゆ よ ら り る れ ろ わ)
      render template: "station/top"
    end
  end

  def suggest
    s = params[:s]
    if s.size >= 1
      stations = Station.where("hiragana like ? or name like ?", "#{s}%", "#{s}%")
    else
      stations = nil
    end
    render json: stations
  end
end
