class SessionsController < ApplicationController
  layout false

  def new
  end

  def create
    user = User.where(:email => params[:email]).first
    if user && user.is_admin? && user.authenticate(params[:password])
      session[:admin_id] = user.id
      redirect_to admin_root_path
    else
      flash[:error] = "Incorrect username/password combination."
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to admin_root_path
  end
  
end
