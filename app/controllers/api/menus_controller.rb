module Api
  
  class MenusController < Api::BaseController
    respond_to :json
    
    def index
      @menu = Menu.current
      @main_items = Item.main
      @side_items = Item.side
      respond_with(menu: @menu, main_items: @main_items, side_items: @side_items)
    end
  end
    
end
