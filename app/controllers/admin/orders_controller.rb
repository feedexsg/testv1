class Admin::OrdersController < Admin::BaseController

  def index
    @orders = Order.all
  end

  def current
    @orders = Order.today
  end

end
