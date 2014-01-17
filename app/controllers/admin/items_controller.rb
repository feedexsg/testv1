class Admin::ItemsController < Admin::BaseController

  before_filter :load_item, :except => [:index, :new, :create]

  def index
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:notice] = "Item has been saved successfully"
      redirect_to admin_items_path
    else
      flash[:error] = "Please fix the errors below"
      render :new
    end
  end

  def edit
  end

  def update
    if @item.update_attributes(item_params)
      flash[:notice] = "Item has been updated successfully"
      redirect_to admin_items_path
    else
      flash[:error] = "Please fix the errors below"
      render :edit
    end
  end

  def destroy
    @item.destroy
    flash[:notice] = "Item has been deleted successfully"
  end

  private

  def item_params
    params.require(:item).permit(:name, :price, :vendor_name, :sku, :category_id, :image)
  end

  def load_item
    @item = Item.where(:id => params[:id]).first
    unless @item
      flash[:error] = "Item not found"
      redirect_to admin_items_path and return
    end
  end

end
