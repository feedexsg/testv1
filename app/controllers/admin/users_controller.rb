class Admin::UsersController < Admin::BaseController

  before_filter :load_user, :except => [:index, :new, :create, :sort]
  before_filter :require_super


  def index
    search_query = params[:search]
    if search_query
      @users = User.where(:email => search_query).page(params[:page])
      if @users.empty?
        @users = User.where{ name =~ "%#{search_query}%"}.page(params[:page])
      end
    else
      @users = params[:sort].present? ? User.order(params[:sort].downcase).page(params[:page]) : User.all.order(created_at: :desc).page(params[:page])
    end

    respond_to do |format|
      format.html
      format.csv do
        userz = User.all.order(created_at: :desc)
        response.headers['Content-Type'] ||= 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=users.csv"
        send_data csviy(userz), :filename => "Users.csv"
      end
    end
  end

  def csviy(users)
    CSV.generate do |csv|
      column_headers = ["User Name", "Email", "Current Credits"]
      csv << column_headers
      users.each do |user|
        loaded_array = []
        loaded_array << user.name
        loaded_array << user.email
        loaded_array << user.total_credits
        csv << loaded_array
      end
    end
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
    @orders = Order.where("user_id = ?", params[:id])
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

  def require_super
    unless @current_admin.role == "super"
      flash[:error] = "Sorry, you are not authorized to access this resource. Off back to Orders you go!"
      redirect_to current_admin_orders_path and return
    end
  end

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
