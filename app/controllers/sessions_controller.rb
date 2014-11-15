class SessionsController < ApplicationController
	layout false

	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		
			if user && user.authenticate(params[:session][:password])
				if user.confirmed_at.nil?
					flash.now[:error] = 'Please confirm your email address first'
					render 'new'
				else
					# Sign in and redirect to menu
					sign_in user
					redirect_to menus_url
				end
			else
				# Create an error message
				flash.now[:error] = 'Invalid email/password combination'
				render 'new'
			end
		
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end
