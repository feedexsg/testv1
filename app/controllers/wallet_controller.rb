class WalletController < ApplicationController
	layout false
	include CurrentCart
	include SessionsHelper
	before_action :set_cart, only: [:index]
	before_action :signed_in_user, only: [:index, :create]
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
		remember_token = User.digest(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token)
		tp_amount = params[:amount]

		puts "AMOUNT RECIEVED__ ****"
		puts tp_amount

		@response = HTTParty.post("https://sandbox.smoovpay.com/redirecturl",
			:body => { 
				:version => "2.0",
				:action => "pay",
				:merchant => "gab.on.rails@gmail.com",
				:ref_id => @current_user.id.to_s,
				:item_name_1 => "Feedex Wallet Top Up",
				:item_description_1 => "Feedex Top Up",
				:item_quantity_1 => "1",
				:item_amount_1 => tp_amount.to_s,
				:currency => "SGD",
				:total_amount => tp_amount.to_s,
				:success_url => "http://app.feedex.sg/wallet",
				:cancel_url => "http://app.feedex.sg/wallet",
				:str_url => "http://app.feedex.sg/payments"
			 },
			 :debug_output => $stdout


			)

		puts "******* REPONSE FROM SMOOVE *********"
		puts @response.to_json

		puts "Done ****"

		redirect_to @response["redirect_url"]


	end

	private
  	def signed_in_user
    	redirect_to signin_url, notice: "Please sign in." unless signed_in?
  	end


end
