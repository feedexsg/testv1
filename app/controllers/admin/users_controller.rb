class Admin::UsersController < Admin::BaseController

  before_filter :load_user, :except => [:index, :new, :create, :sort]

  def index
    @users = params[:sort].present? ? User.order(params[:sort].downcase) : User.all.order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.confirmed_at = DateTime.now
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

  def credits
  end

  def add_credits
    if @user.update_attributes(user_params)
      flash[:notice] = "Credits added successfully"
      redirect_to admin_users_path
    else
      flash[:error] = "Please fix the errors below"
      render :credits
    end
  end

  def destroy
    unless @user.is_admin?
      @user.destroy
      flash[:notice] = "User has been deleted successfully"
    else
      flash[:error] = "User cannot be deleted"
    end
    redirect_to admin_users_path
  end

  def notify
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :mobile,
                                 :colony_id, :confirmed_at, credits_attributes: [:amount, :source])
  end

  def load_user
    @user = User.where(:id => params[:id]).first
    unless @user
      flash[:error] = "User not found"
      redirect_to admin_users_path and return
    end
  end

end
