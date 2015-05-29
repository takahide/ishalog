class ContactController < ApplicationController
  def index

  end
  def create
    Contact.where(name: params[:name], email: params[:email], message: params[:message]).first_or_create do |c|
    end
    json = {}
    render json: json
  end
end
