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
     
      @total_price += main.price.to_f
      @total_price += side.price.to_f
  		@order_items_array << packed_hash
  	end

  	Rails.logger.info "******* EMAIL WAS SENT THRU ORDER MAILER *******"
    subject_title = "Show This to the Feedex Crew! [##{@order.id}]"
  	mail(to: @user.email, bcc: "gabriel@gettingrail.com; admin@feedex.sg", subject: subject_title)
  end

  def send_account_activation_email(account)
    Rails.logger.info "**** ACTIVATION EMAIL WAS SENT THROUGH ORDER MAILER ****"

    @user = account
    token = @user.confirmation_token.to_s
    @confirmation_link = "http://app.feedex.sg/confirm?confirmation=" + token
    mail(to: @user.email, bcc: "gabriel@gettingrail.com; admin@feedex.sg", subject: "Please Confirm Your Account")
  end

  def send_top_up_confirmation_email(info_hash)
    Rails.logger.info "**** TOP UP EMAIL WAS SENT THROUGH ORDER MAILER ****"

    @info_hash = info_hash

    user_email = info_hash[:user_email]

    mail(to: user_email, bcc: "gabriel@gettingrail.com; admin@feedex.sg", subject: "Top Up Confirmation")
  
  end

  def send_password_reset_email(user)
    Rails.logger.info "**** PASSWORD RESET EMAIL WAS SENT THROUGH ORDER MAILER ****"
    @user = user
    mail(to: user.email, bcc: "gabriel@gettingrail.com; admin@feedex.sg", subject: "Password Reset Requested")
  end

  def send_beta_welcome_email(user)
    Rails.logger.info "**** BETA WELCOME EMAIL WAS SENT THROUGH ORDER MAILER ****"
    @user = user
    mail(to: @user.email, bcc: "gabriel@gettingrail.com; admin@feedex.sg", subject: "Welcome to Feedex")

  end


end
