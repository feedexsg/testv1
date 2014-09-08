class Admin::PagesController < Admin::BaseController

  def index
    @total_credits = Credit.all.collect(&:amount).sum.to_f
    @used_credits = Order.all.collect(&:amount).sum.to_f
    @manual_credits = Credit.manual.collect(&:amount).sum.to_f
    
    @credits = Credit.all.order(created_at: :desc).page(params[:page])
  end

end
