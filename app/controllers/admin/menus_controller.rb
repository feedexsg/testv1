class Admin::MenusController < Admin::BaseController

  def index
    @menu = Menu.current
    @main_items = Item.main
    @side_items = Item.side
  end

end
