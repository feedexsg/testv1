class Admin::DeliveryLocationsController < Admin::BaseController

  before_filter :load_delivery_location, :except => [:index, :new, :create]

  def index
    @delivery_locations = DeliveryLocation.all
  end

  def new
    @delivery_location = DeliveryLocation.new
  end

  def create
    @delivery_location = DeliveryLocation.new(delivery_location_params)
    if @delivery_location.save
      flash[:notice] = "Delivery Location has been saved successfully"
      redirect_to admin_delivery_locations_path
    else
      flash[:error] = "Please fix the errors below"
      render :new
    end
  end

  def edit
  end

  def update
    if @delivery_location.update_attributes(delivery_location_params)
      flash[:notice] = "Delivery Location has been updated successfully"
      redirect_to admin_delivery_locations_path
    else
      flash[:error] = "Please fix the errors below"
      render :edit
    end
  end

  def destroy
    @delivery_location.destroy
    flash[:notice] = "Delivery Location has been deleted successfully"
    redirect_to admin_delivery_locations_path
  end

  private

  def delivery_location_params
    params.require(:delivery_location).permit(:name, :delivery_timing, :colony_id)
  end

  def load_delivery_location
    @delivery_location = DeliveryLocation.where(:id => params[:id]).first
    unless @delivery_location
      flash[:error] = "Delivery Location not found"
      redirect_to admin_delivery_locations_path and return
    end
  end

end
