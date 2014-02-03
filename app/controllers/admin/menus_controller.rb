class Admin::MenusController < Admin::BaseController

  before_filter :load_current_menu, only: [:index, :create, :update]

  def index
  end

  def create
    save_menu
  end

  def update
    save_menu
  end

  private

  def menu_params
    params.require(:menu).permit(:status, :start_timeselect, :end_timeselect, main_items_menus_attributes: [:item_id, :quantity,
                                 :availability_time_select, :item_type, :_destroy], side_items_menus_attributes: [:item_id, :quantity,
                                 :availability_time_select, :item_type, :_destroy])
  end

  def load_current_menu
    @menu = Menu.current
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

end
