module Api
  
  class OrdersController < Api::BaseController
    respond_to :json

    def redeem
      @order = Order.where(:id => params[:id]).first
      if @order
        if @order.redeemed
          render json: { success: false, error_message: "Order is already redeemed." }.to_json
        else
          @order.redeemed = true
          @order.save
          render json: { success: true, success_message: "Order redeemed.", order: @order }.to_json
        end
      else
        render json: { success: false, error_message: "Order doesn't exist.", }.to_json
      end
    end
    
    def create
      begin
        temp_params = order_params
        order = Order.new(:user_id => temp_params[:user_id], :delivery_time => temp_params[:delivery_time])
        # order.calculate_amount

        # Get Total Dollar Amount 
        #total_amt = 0
        #order_params[:items].each do |i|
        #  item = Item.find_by_id(i["id"])
        #  total_amt += (item.price.to_f * i["quantity"].to_i) if item
        #end

        #order.amount = total_amt
        
        # Get Total Dollar Amount
        total_amt = 0
        item_sets = order_params[:item_sets]
        item_sets.each do |i|
          main_item = Item.find_by_id(i["main_id"])
          side_item = Item.find_by_id(i["side_id"])
          total_amt += main_item.price.to_f if main_item
          total_amt += side_item.price.to_f if side_item
        end

        if @current_user.total_credits > total_amt # order.amount ORDER AMOUNT
          if order.save
            order_params[:items].each do |item|
              orderitem = OrderItem.new(:order_id => order.id, :items_id => item["id"].to_i, :amount => item["quantity"].to_i) if item
              orderitem.save!
            end
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
        return params[:order].permit(:user_id, :delivery_time, :item_sets => [:main_id, :side_id], )
      end
    end

  end

end
