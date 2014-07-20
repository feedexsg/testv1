require 'digest/sha1'
class PaymentsController < ApplicationController
	protect_from_forgery with: :null_session
	respond_to :json

	def create
		Rails.logger.info "****** Receving parameters from SmoovPay... ******"
		Rails.logger.info params

		Rails.logger.info "Trying to get merchant..."
		Rails.logger.info params[:merchant]

		Rails.logger.info "Getting Signature....."
		Rails.logger.info "**** Signature *****"
		Rails.logger.info params[:signature]

		secret_key = "0db5a5b4cc2840009ff2c2c98a520582"
		merchant = params[:merchant]
		ref_id = params[:ref_id]
		reference_code = params[:reference_code]
		response_code = params[:response_code]
		currency = params[:currency]
		total_amount = params[:total_amount]
		signature = params[:signature]
		signature_algorithm = params[:signature_algorithm]

		data_to_be_hashed = secret_key + merchant + ref_id + reference_code + response_code + currency + total_amount

		utf_string = data_to_be_hashed.encode('utf-8')
		check_signature = Digest::SHA1.hexdigest utf_string

		Rails.logger.info "**** Check Signature *****"
		Rails.logger.info check_signature


		if (params[:signature] == check_signature)
			Rails.logger.info "DING DING DING MATCH!"
			purchasing_user = User.find(ref_id.to_i)
			credit = Credit.new(amount: total_amount, user_id: purchasing_user.id, source: "Direct")
			if credit.save
				Rails.logger.info "Credit was saved!"
			else
				Rails.logger.info "Something went wrong when saving the credits"
			end
		else
			Rails.logger.info "BLEAH DO NOT MATCH!"
		end
		render :nothing => true
	end
end