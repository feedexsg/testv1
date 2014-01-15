class Admin::ItemsController < Admin::BaseController

  def index
    @items = Item.all
  end

  def new
    @item = Item.new
  end

end
