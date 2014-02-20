module Api
  
  class MenusController < Api::BaseController
    respond_to :json
    
    def index
      @menu = Menu.current
      @main_items = Item.main
      @side_items = Item.side
      respond_with @menu
    end
  end
    
end