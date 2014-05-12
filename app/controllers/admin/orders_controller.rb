class Admin::OrdersController < Admin::BaseController

  def index
    @orders = Order.all
  end

  def current
      @orders = Order.today.where(:redeemed => false) #Order.where('delivery_time BETWEEN ? AND ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day).where(:user_id => @current_user.id, :redeemed => false)
      
      @sorted_orders = @orders.group_by do |order|
        order.user_id
      end

  end



end
