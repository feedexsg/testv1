class Notifier < ActionMailer::Base
  default from: "from@example.com"

  def welcome_notification(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to Feedex")
  end

  def order_notification(user)
    @user = user
    mail(to: @user.email, subject: "Your order has been placed!")
  end

  def credit_notification(user, credit)
    @user = user
    @credit = credit
    mail(to: @user.email, subject: "Credits have been added to your account!")
  end

end
