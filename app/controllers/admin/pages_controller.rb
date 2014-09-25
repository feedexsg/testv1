class Admin::PagesController < Admin::BaseController
  before_filter :require_super
  
  def index
    @total_credits = Credit.direct.collect(&:amount).sum.to_f
    @used_credits = Order.all.collect(&:amount).sum.to_f
    @manual_credits = Credit.manual.collect(&:amount).sum.to_f
    
    @credits = Credit.all.order(created_at: :desc).page(params[:page])

    respond_to do |format|
      format.html
      format.csv do
        creditz = Credit.all.order(created_at: :desc)
        response.headers['Content-Type'] ||= 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=credits.csv"
        send_data csviy(creditz), :filename => "Credits.csv"
      end
    end
  end

  def csviy(credits)
    CSV.generate do |csv|
      column_headers = ["User", "Amount", "Date"]
      csv << column_headers
      credits.each do |credit|
        loaded_array = []
        loaded_array << credit.user.name
        loaded_array << credit.amount
        loaded_array << credit.created_at.strftime("%d %B, %Y %H : %M")
        csv << loaded_array
      end
    end
  end

  private
  def require_super
    unless @current_admin.role == "super"
      flash[:error] = "Sorry, you are not authorized to access this resource. Off back to Orders you go!"
      redirect_to current_admin_orders_path and return
    end
  end

end
