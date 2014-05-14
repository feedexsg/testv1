class Admin::OrdersController < Admin::BaseController

  def index
    @orders = Order.all.order(created_at: :desc)
  end

  def current
      @orders = Order.today.where(:redeemed => false) #Order.where('delivery_time BETWEEN ? AND ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day).where(:user_id => @current_user.id, :redeemed => false)
      
      @sorted_orders = @orders.group_by do |order|
        order.user_id
      end

      @large_array = []

      @sorted_orders.each do |group_of_orders|
      	big_hash = {}
      	user_id = group_of_orders.shift
      	big_hash["username"] = User.find(user_id).name
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
              		end # end of item_sets_array.each do 
              		item_sets_array << itemset_hash if add_to_array
      			end # end of order.order_items.each do
      		end # end of order_group.each do
      	end # end of group_of_orders.each do
      	item_sets_array.each do |hash_arr|
          hash_arr.delete("main_id")
          hash_arr.delete("side_id")
        end
      	big_hash["item_sets"] = item_sets_array
      	@large_array << big_hash
      end # end of sorted_orders.each do
  end

  def current_redeemed
    @orders = Order.today.where(:redeemed => true) #Order.where('delivery_time BETWEEN ? AND ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day).where(:user_id => @current_user.id, :redeemed => false)
      
      @sorted_orders = @orders.group_by do |order|
        order.user_id
      end

      @large_array = []

      @sorted_orders.each do |group_of_orders|
        big_hash = {}
        user_id = group_of_orders.shift
        big_hash["username"] = User.find(user_id).name
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
                  end # end of item_sets_array.each do 
                  item_sets_array << itemset_hash if add_to_array
            end # end of order.order_items.each do
          end # end of order_group.each do
        end # end of group_of_orders.each do
        item_sets_array.each do |hash_arr|
          hash_arr.delete("main_id")
          hash_arr.delete("side_id")
        end
        big_hash["item_sets"] = item_sets_array
        @large_array << big_hash
      end # end of sorted_orders.each do

  end



end
