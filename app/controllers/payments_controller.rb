class PaymentsController < ApplicationController
	protect_from_forgery with: :null_session
	respond_to :json

	def create
		Rails.logger.info "****** Receving parameters from SmoovPay... ******"
		Rails.logger.info params

		render nil



	end

	
end
