class Admin::BaseController < ApplicationController

  before_filter :current_admin
  before_filter :require_authentication

  private

  def current_admin
    @current_admin = User.find_by_id(session[:admin_id])
  end

  def require_authentication
    unless @current_admin
      flash[:error] = "Please Login"
      redirect_to new_admin_session_path and return
    end
  end

end
