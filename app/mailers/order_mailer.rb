class OrderMailer < ActionMailer::Base
  default from: "Feedex <admin@feedex.sg>"

  def send_order_confirmation_email(order)
  	Rails.logger.info "******* EMAIL WAS SENT THRU ORDER MAILER *******"
  	mail(to: "gabriel@gettingrail.com", subject: "Feedex needs you!")
  end
end
