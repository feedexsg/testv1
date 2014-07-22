class Admin::SessionsController < Admin::BaseController

  layout 'login'
  skip_before_filter :require_authentication, except: :destroy

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
    session.delete(:admin_id)
    redirect_to root_url
  end

end
