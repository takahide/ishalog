class StationController < ApplicationController
  def show
    @stations = Station.page(params[:page])
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
