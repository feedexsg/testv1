class Admin::MenusController < Admin::BaseController

  before_filter :load_current_menu, only: [:index, :create, :update]
  before_filter :require_super

  def index
  end

  def create
    save_menu
  end

  def update
    status = menu_params[:status]
    if status == "0"
      # Clear all carts
      LineItem.all.each do |x|
        x.delete
      end
      Cart.all.each do |x|
        x.delete
      end
    end
    save_menu
  end

  private

  def menu_params
    params.require(:menu).permit(:id, :status, :start_time, :end_time, main_items_menus_attributes: [:id, :item_id, :quantity,
                                 :availability_time, :item_type, :_destroy], side_items_menus_attributes: [:id, :item_id, :quantity,
                                 :availability_time, :item_type, :_destroy])
  end

  def load_current_menu
    @menu = Menu.last #Menu.current
    @main_items = Item.main
    @side_items = Item.side
  end

  def save_menu
    @menu.attributes = menu_params
    if @menu.save
      flash[:notice] = "Menu has been saved successfully"
      redirect_to admin_menus_path
    else
      flash[:error] = "Please fix the errors below"
      render :index
    end
  end

  def require_super
    unless @current_admin.role == "super"
      flash[:error] = "Sorry, you are not authorized to access this resource. Off back to Orders you go!"
      redirect_to current_admin_orders_path and return
    end
  end

end
