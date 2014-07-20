class OrdersController < ApplicationController
	layout false
	include CurrentCart
	before_action :set_cart, only: [:index]
	def index
		
	end

	def create
		remember_token = User.digest(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token)
		order = Order.new(:user_id => @current_user.id, :delivery_time => order_params[:delivery_time])

		total_amt = 0
		item_sets = order_params[:item_sets]
		item_sets.each do |i|
			main_item = Item.find_by_id(i["main_id"])
			side_item = Item.find_by_id(i["side_id"])
			total_amt += main_item.price.to_f if main_item
          	total_amt += side_item.price.to_f if side_item
		end

		order.amount = total_amt

		if @current_user.total_credits > total_amt
			if order.save
				order_params[:item_sets].each do |item|
					orderitem = OrderItem.new(:order_id => order.id, :main_id => item["main_id"].to_i, :side_id => item["side_id"].to_i) if item
              		orderitem.save!
				end

				# Send email confirmation
				OrderMailer.send_order_confirmation_email(order).deliver
				
				redirect_to orders_url
			else
				# Invalid order
				# Refer to Saleswhale for error handling
				puts "Invalid ORDER ***@*@"
			end
		else
			# Insufficent balance
			# Refer to Saleswhale for error handling
			puts "Insufficent Balance ****@***"
		end

	end

	private
	def order_params
		if params[:order].present?
        	params[:order].merge!({user_id: @current_user.id})
        	return params[:order].permit(:user_id, :delivery_time, :item_sets => [:main_id, :side_id] )
      	end
	end

end
