class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActionController::RoutingError, with: :rescue404 if Rails.env.production?

  def rescue404 e
    @exception = e
    render 'errors/not_found', status: 404
  end
end
