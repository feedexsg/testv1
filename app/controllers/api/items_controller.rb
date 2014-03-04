module Api
  
  class ItemsController < Api::BaseController
    respond_to :json
    
    def index
      @items = Item.all
      respond_with @items
    end

    def show
      @item = Item.where(id: params[:id]).first
      respond_with @item
    end

    def available
      @items = Item.available
      respond_with @items    
    end

    # sort by categories
    def sort
      category = Category.where(:name => params[:category]).first
      @items = category.present? ? Item.where(category_id: category.id) : []
      respond_with @items    
    end

  end
    
end
