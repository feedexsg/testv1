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
  		redirect_to root_url
  	else
  		flash[:error] = @user.errors.full_messages
  		render :new
  	end
  end

  private

  def user_params
  	params.require(:user).permit(:name, :email, :password, :password_confirmation,
                                 :colony_id, credits_attributes: [:amount, :source])
  end
  
end