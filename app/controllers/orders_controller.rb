class OrdersController < ApplicationController
	layout false
	include CurrentCart
	before_action :set_cart, only: [:index, :create]
	def index
		
	end

	def create
		remember_token = User.digest(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token)
		order = Order.new(:user_id => @current_user.id, :delivery_time => order_params[:delivery_time])

		total_amt = 0
		item_sets = order_params[:item_sets]

		main_count = []

		item_sets.each do |i|
			main_item = Item.find_by_id(i["main_id"])
			side_item = Item.find_by_id(i["side_id"])
			if side_item.price.to_f == 0
			total_amt += main_item.price.to_f if main_item
          	total_amt += side_item.price.to_f if side_item
          else 
          	total_amt += 0.9 * main_item.price.to_f if main_item
          	total_amt += 0.9 * side_item.price.to_f if side_item
          end
          	main_count_hash = {}
          	main_count_hash[:item_id] = main_item.id
          	main_count_hash[:item] = main_item
          	main_count_hash[:count] = 1
          	main_add_to_array = true
          	main_count.each do |check_count|
          		if check_count[:item_id] == main_count_hash[:item_id]
          			add_to_array = false
          			check_count[:count] += 1
          			break
          		end
          	end
          	main_count << main_count_hash if main_add_to_array

          	side_count_hash = {}
          	side_count_hash[:item_id] = side_item.id
          	side_count_hash[:item] = side_item
          	side_count_hash[:count] = 1
          	side_add_to_array = true
          	main_count.each do |check_count|
          		if check_count[:item_id] == side_count_hash[:item_id]
          			add_to_array = false
          			check_count[:count] += 1
          			break
          		end
          	end
          	main_count << side_count_hash if side_add_to_array
		end

		main_count.each do |item_hash|
			item = item_hash[:item]
			if item.items_menus.last.quantity < item_hash[:count]
				redirect_to menus_url, :flash => { :error => "#{item.name} sold out!" } and return
			end
		end

		order.amount = total_amt

		if @current_user.total_credits >= total_amt
			if order.save
				order_params[:item_sets].each do |item|
					orderitem = OrderItem.new(:order_id => order.id, :main_id => item["main_id"].to_i, :side_id => item["side_id"].to_i) if item
              		orderitem.save!
				end

				# Reduce quantity
				item_sets.each do |i|
					main_item = Item.find_by_id(i["main_id"])
					side_item = Item.find_by_id(i["side_id"])
					main_item.items_menus.last.decrement!(:quantity)
					side_item.items_menus.last.decrement!(:quantity)
				end

				# Send email confirmation
				OrderMailer.send_order_confirmation_email(order).deliver

				# Delete current cart items
				@cart.line_items.each do |l|
					l.delete
				end
				
				redirect_to orders_url and return
			else
				# Invalid order
				# Refer to Saleswhale for error handling
				puts "Invalid Order"
			end
		else
			# Insufficent balance
			# Refer to Saleswhale for error handling
			puts "Insufficent Balance "
			redirect_to menus_url and return
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
