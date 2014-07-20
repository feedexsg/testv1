class PaymentsController < ApplicationController
	protect_from_forgery with: :null_session
	respond_to :json

	def create
		Rails.logger.info "****** Receving parameters from SmoovPay... ******"
		Rails.logger.info params

		Rails.logger.info "Trying to get merchant..."
		Rails.logger.info params[:merchant]

		render nil



	end

	
end
