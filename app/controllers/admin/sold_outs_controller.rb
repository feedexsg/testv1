class Admin::SoldOutsController < Admin::BaseController

  before_filter :load_item, :except => [:index, :new, :create]

  def index
    @soldouts = SoldOut.all
  end

  def new
    @soldout = SoldOut.new
  end

  def create
    @soldout = SoldOut.new(sold_out_params)
    if @soldout.save
      flash[:notice] = "Item has been saved successfully"
      redirect_to admin_sold_outs_path
    else
      flash[:error] = "Please fix the errors below"
      render :new
    end
  end

  def edit
  end

  def update
    if @soldout.update_attributes(sold_out_params)
      flash[:notice] = "Item has been updated successfully"
      redirect_to admin_sold_outs_path
    else
      flash[:error] = "Please fix the errors below"
      render :edit
    end
  end

  def destroy
    @soldout.destroy
    flash[:notice] = "Item has been deleted successfully"
    redirect_to admin_sold_outs_path
  end

  private

  def sold_out_params
    params.require(:sold_out).permit(:image, :item_id)
  end

  def load_item
    @soldout = SoldOut.where(:id => params[:id]).first
    unless @soldout
      flash[:error] = "Item not found"
      redirect_to admin_sold_outs_path and return
    end
  end

end
