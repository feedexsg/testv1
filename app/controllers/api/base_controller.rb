class Api::BaseController < ApplicationController
  before_filter :restrict_access, except: [:route_not_found]
  protect_from_forgery with: :null_session
  
  def route_not_found
    response = {success: false, error_message: "No such api route exists"}
    render json: response.to_json
  end
  
  private
  
  def restrict_access
    auth_key = request.headers["X-Auth"]
    user = User.find_by_auth_key(auth_key) unless auth_key.blank?
    response = {success: false, error_message: "Invalid Key!"} unless user
    @current_user = user
    render json: response.to_json if response
  end
  
  def generate_auth_key(user)
    auth_key = SecureRandom.hex
    generate_auth_key(user) if User.exists?(auth_key: auth_key)
    user.auth_key = auth_key
  end
  
end
