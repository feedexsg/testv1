class WalletController < ApplicationController
	layout false
	include CurrentCart
	before_action :set_cart, only: [:index]
	def index
		remember_token = User.digest(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token)
		@credits = @current_user.total_credits

		@topup = nil

		if params[:topup]
			top_up_amount = params[:topup]
			if top_up_amount.to_f > 10.0
				@topup = top_up_amount.to_f
			else
				@topup = 10.0
			end
		end
	end

	def create
	end
end
