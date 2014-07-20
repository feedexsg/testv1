class OrderMailer < ActionMailer::Base
  default from: "Feedex <admin@feedex.sg>"

  def send_order_confirmation_email(order)
  	@order = order
  	order_items = @order.order_items

  	@order_items_array = []
  	@total_price = 0.0

    @user = User.find(@order.user_id)

  	order_items.each do |item|
  		packed_hash = {}
  		main = Item.find(item.main_id)
  		side = Item.find(item.side_id)
  		packed_hash[:main] = main.name
  		packed_hash[:side] = side.name
  		packed_hash[:subprice] = main.price.to_f + side.price.to_f

  		@total_price += main.price.to_f + side.price.to_f

  		@order_items_array << packed_hash
  	end

  	Rails.logger.info "******* EMAIL WAS SENT THRU ORDER MAILER *******"
  	mail(to: "gabriel@gettingrail.com", subject: "Feedex needs you!")
  end
end
