class Admin::UsersController < Admin::BaseController

  before_filter :load_user, :except => [:index, :new, :create]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "User has been saved successfully"
      redirect_to admin_users_path
    else
      flash[:error] = "Please fix the errors below"
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = "User has been updated successfully"
      redirect_to admin_users_path
    else
      flash[:error] = "Please fix the errors below"
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = "User has been deleted successfully"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :colony)
  end

  def load_user
    @user = User.where(:id => params[:id]).first
    unless @user
      flash[:error] = "User not found"
      redirect_to admin_users_path and return
    end
  end

end
