class Admin::ColoniesController < Admin::BaseController

  before_filter :load_colony, :except => [:index, :new, :create]

  def index
    @colonies = Colony.all
  end

  def new
    @colony = Colony.new
  end

  def create
    @colony = Colony.new(colony_params)
    if @colony.save
      flash[:notice] = "Colony has been saved successfully"
      redirect_to admin_colonies_path
    else
      flash[:error] = "Please fix the errors below"
      render :new
    end
  end

  def edit
  end

  def update
    if @colony.update_attributes(colony_params)
      flash[:notice] = "Colony has been updated successfully"
      redirect_to admin_colonies_path
    else
      flash[:error] = "Please fix the errors below"
      render :edit
    end
  end

  def destroy
    @colony.destroy
    flash[:notice] = "Colony has been deleted successfully"
    redirect_to admin_colonies_path
  end

  private

  def colony_params
    params.require(:colony).permit(:name)
  end

  def load_colony
    @colony = Colony.where(:id => params[:id]).first
    unless @colony
      flash[:error] = "Colony not found"
      redirect_to admin_colonies_path and return
    end
  end

end
