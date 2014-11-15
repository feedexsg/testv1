class SettingsController < ApplicationController
	layout false
	include CurrentCart
	include SessionsHelper
	before_action :set_cart, only: [:index]
	before_action :signed_in_user, only: [:index, :create]

	def index
		remember_token = User.digest(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token)
		@user = @current_user
	end

	def create
	end

	private
  	def signed_in_user
    	redirect_to signin_url, notice: "Please sign in." unless signed_in?
  	end

end