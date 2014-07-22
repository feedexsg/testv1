class UsersController < ApplicationController
  layout false
  def index
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      # Send mailer
      OrderMailer.send_account_activation_email(@user).deliver
  		redirect_to signup_success_url
  	else
  		flash[:error] = @user.errors.full_messages
  		render :new
  	end
  end

  def signup_success
  end

  def confirm
    confirmation_token = params[:confirmation]
    user = User.where(confirmation_token: confirmation_token).first
    if user
      user.confirmed_at = DateTime.now
      user.save!
      sign_in user
      redirect_to menus_url
    else
      flash[:error] = "Sorry, something went wrong."
      redirect_to root_url
    end
  end

  private

  def user_params
  	params.require(:user).permit(:name, :email, :password, :password_confirmation,
                                 :colony_id, credits_attributes: [:amount, :source])
  end

  
end