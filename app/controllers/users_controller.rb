class UsersController < ApplicationController
  layout false
  include SessionsHelper
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

  def update
    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)

    if @current_user.update_attributes(user_params)
      flash[:notice] = "Your account settings were successfully updated."
      redirect_to settings_url
    else
      flash[:error] = @current_user.errors.full_messages[0].to_s
      redirect_to settings_url
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