module Api
  
  class OrdersController < Api::BaseController
    respond_to :json
    
    def create
      begin
        order = Order.new(params[:order])
        if order.save
          @response = {success: true, success_message: "Order created", order: order}
        else
          @response = {success: false, error_message: "Invalid order", errors: order.errors}
        end
      rescue Exception => e
        @response = {success: false, error_message: "error processing request, please try again later!"}
        Rails.logger.error "Stacktrace: \n\t#{e.backtrace.join("\n\t")}"
      end
      respond_with @response.to_json
    end

  end
    
end
