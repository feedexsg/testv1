class PasswordResetsController < ApplicationController
	def create
		user = User.find_by_email(params[:email])
		user.send_password_reset if user
		redirect_to signin_path, :notice => "Email sent with password reset instructions."
	end

	def edit
		@user = User.find_by_reset_password_token!(params[:id])
	end

	def update
		@user = User.find_by_reset_password_token!(params[:id])
		if @user.reset_password_sent_at < 2.hours.ago
			redirect_to new_password_reset_path, :alert => "Password reset has expired."
		elsif @user.update_attributes(user_params)
			redirect_to signin_path, :notice => "Password has been reset!"
		else
			render :edit
		end
	end

	private

	  def user_params
	  	params.require(:user).permit(:name, :email, :mobile, :password, :password_confirmation,
	                                 :colony_id, credits_attributes: [:amount, :source])
	  end

end