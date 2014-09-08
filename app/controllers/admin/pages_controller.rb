class Admin::PagesController < Admin::BaseController
  before_filter :require_super
  
  def index
    @total_credits = Credit.direct.collect(&:amount).sum.to_f
    @used_credits = Order.all.collect(&:amount).sum.to_f
    @manual_credits = Credit.manual.collect(&:amount).sum.to_f
    
    @credits = Credit.all.order(created_at: :desc).page(params[:page])
  end

  private
  def require_super
    unless @current_admin.role == "super"
      flash[:error] = "Sorry, you are not authorized to access this resource. Off back to Orders you go!"
      redirect_to current_admin_orders_path and return
    end
  end

end
