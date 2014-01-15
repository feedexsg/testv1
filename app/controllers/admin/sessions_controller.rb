class Admin::SessionsController < Admin::BaseController

  skip_before_filter :require_authentication, except: :destroy

  def new
  end

  def create
    user = User.where(:email => params[:email]).first
    if user && user.authenticate(params[:password])
      session[:admin_id] = user.id
      redirect_to admin_root_path
    else
      flash[:error] = "Incorrect username/password combination."
      render :new
    end
  end

end
