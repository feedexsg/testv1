module Api
  
  class OrdersController < Api::BaseController
    respond_to :json

    def index
      @orders = Order.where(:user_id => @current_user.id, :redeemed => true).order(delivery_time: :desc)

      @sorted_orders = @orders.group_by do |order|
        order.delivery_time.to_date
      end

      # Join all order item sets to a big array

      large_array =[]

      @sorted_orders.each do |group_of_orders|
        # big_array = []
        big_hash = {}
        big_hash["delivery_date"] = date
        item_sets_array = []
        group_of_orders.each do |order_group|
          order_group.each do |order|
            order.order_items.each do |order_item|
              itemset_hash = {}
              itemset_hash["main_id"] = order_item.main_id
              itemset_hash["main_title"] = Item.find(order_item.main_id).name
              itemset_hash["side_id"] = order_item.side_id
              itemset_hash["side_title"] = Item.find(order_item.side_id).name
              itemset_hash["quantity"] = 1

              add_to_array = true

              item_sets_array.each do |check_set|
                if check_set["main_id"] == itemset_hash["main_id"] && check_set["side_id"] == itemset_hash["side_id"]
                  add_to_array = false
                  check_set["quantity"] += 1
                  break
                end
              end

              item_sets_array << itemset_hash if add_to_array
            end
            
          end
        end
        item_sets_array.each do |hash_arr|
          hash_arr.delete("main_id")
          hash_arr.delete("side_id")
        end
        big_hash["item_sets"] = item_sets_array
        large_array << big_hash
      end

      render json: large_array 

    end

    def current
      @orders = Order.today.where(:user_id => @current_user.id, :redeemed => false) #Order.where('delivery_time BETWEEN ? AND ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day).where(:user_id => @current_user.id, :redeemed => false)
      
      # Refactor - order ids
      order_ids = []
      @orders.each do |ord|
        order_ids << ord.id
      end

      big_hash = {}
      big_hash["order_ids"] = order_ids
      big_hash["delivery_date"] = Date.today
      big_hash["collection_venue"] = "Chevron House"
      big_hash["collection_time"] = "11:30 to 13:30"

      item_sets_array = []

      @orders.each do |order|
        order.order_items.each do |order_item|
          itemset_hash = {}
            itemset_hash["main_id"] = order_item.main_id
            itemset_hash["main_title"] = Item.find(order_item.main_id).name
            itemset_hash["side_id"] = order_item.side_id
            itemset_hash["side_title"] = Item.find(order_item.side_id).name
            itemset_hash["quantity"] = 1

            add_to_array = true

            item_sets_array.each do |check_set|
              if check_set["main_id"] == itemset_hash["main_id"] && check_set["side_id"] == itemset_hash["side_id"]
                 add_to_array = false
                 check_set["quantity"] += 1
                 break
              end
            end

            item_sets_array << itemset_hash if add_to_array
        end
      end
      item_sets_array.each do |hash_arr|
          hash_arr.delete("main_id")
          hash_arr.delete("side_id")
      end
      big_hash["item_sets"] = item_sets_array
 

      render json: big_hash



    end

    def redeem
      order_references = params[:order_ids]
      order_references.each do |order_ref|
        order = Order.where(:id => order_ref.to_i).first
        order.redeemed = true if order
        order.save if order
      end
      render json: { success: true, success_message: "Orders redeemed.", order_ids: order_references }.to_json



      #@order = Order.where(:id => params[:id]).first
      #if @order
      #  if @order.redeemed
      #    render json: { success: false, error_message: "Order is already redeemed." }.to_json
      #  else
      #    @order.redeemed = true
      #    @order.save
       #   render json: { success: true, success_message: "Order redeemed.", order: @order }.to_json
      #  end
      #else
      #  render json: { success: false, error_message: "Order doesn't exist.", }.to_json
      #end
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

        order.amount = total_amt

        if @current_user.total_credits > total_amt # order.amount ORDER AMOUNT
          if order.save
            order_params[:item_sets].each do |item|
              orderitem = OrderItem.new(:order_id => order.id, :main_id => item["main_id"].to_i, :side_id => item["side_id"].to_i) if item
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
