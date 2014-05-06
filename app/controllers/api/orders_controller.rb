module Api
  
  class OrdersController < Api::BaseController
    respond_to :json
    
    def create
      begin
        order = Order.new(order_params)
        order.calculate_amount
        if @current_user.total_credits > order.amount
          if order.save
            @response = {success: true, success_message: "Order created", order: order}
          else
            @response = {success: false, error_message: "Invalid order", errors: order.errors}
          end
        else
          @response = {success: false, error_message: "Insufficient balance", errors: order.errors}
        end
      end
      render json: @response.to_json
    end

    private
    def order_params
      if params[:order].present?
        params[:order].merge!({user_id: @current_user.id})
        return params[:order].permit(:user_id, :delivery_time, :items => [:id, :quantity])
      end
    end

  end

end
