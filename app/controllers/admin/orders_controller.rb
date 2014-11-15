class Admin::OrdersController < Admin::BaseController

  def index
    @orders = Order.all.order(created_at: :desc).page(params[:page])
  end

  def redeem
    order_id = params[:order_id]
    if order_id
      order = Order.find(order_id)
      order.redeemed = true
      order.save if order
    end
    redirect_to current_admin_orders_path
  end

  def revert
    order_id = params[:order_id]
    if order_id
      order = Order.find(order_id)
      order.redeemed = false
      order.save if order
    end
    redirect_to current_admin_orders_path
  end

  def current
      search_query = params[:search]
      if search_query
        # Search by id first
        @orders = Order.where(:created_at => (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).where(:redeemed => false, :id => search_query).order(id: :desc)
        # @orders = Order.today.where(:redeemed => false, :id => search_query).order(id: :desc)
        if @orders.empty?
          users_with_name = User.where{ name =~ "%#{search_query}%"}

          if users_with_name && !users_with_name.empty?
            @orders = Order.where(:created_at => (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).where(:redeemed => false, :user_id => users_with_name.collect(&:id)).order(id: :desc)
          end
          if @orders.empty?
            user_with_email = User.find_by_email(search_query)
            if user_with_email
              @orders = Order.where(:created_at => (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).where(:redeemed => false, :user_id => user_with_email.id).order(id: :desc)
            end
            if @orders.empty?
              @empty_order = "No Results Found!"

            end

          end
          
        end

      else
        @orders = Order.where(:created_at => (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).where(:redeemed => false).order(id: :desc) #Order.where('delivery_time BETWEEN ? AND ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day).where(:user_id => @current_user.id, :redeemed => false)

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
                itemset_hash["main_title"] = Item.with_deleted.find(order_item.main_id).name
                itemset_hash["side_id"] = order_item.side_id
                    itemset_hash["side_title"] = Item.with_deleted.find(order_item.side_id).name
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

  def current_redeemed
    search_query = params[:search]
      if search_query
        # Search by id first
        @orders = Order.where(:created_at => (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).where(:redeemed => true, :id => search_query).order(id: :desc)
        if @orders.empty?
          users_with_name = User.where{ name =~ "%#{search_query}%"}

          if users_with_name && !users_with_name.empty?
            @orders = Order.where(:created_at => (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).where(:redeemed => true, :user_id => users_with_name.collect(&:id)).order(id: :desc)
          end
          if @orders.empty?
            user_with_email = User.find_by_email(search_query)
            if user_with_email
              @orders = Order.where(:created_at => (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).where(:redeemed => true, :user_id => user_with_email.id).order(id: :desc)
            end
            if @orders.empty?
              @empty_order = "No Results Found!"

            end

          end
          
        end

      else
        @orders = Order.where(:created_at => (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).where(:redeemed => true).order(id: :desc) #Order.where('delivery_time BETWEEN ? AND ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day).where(:user_id => @current_user.id, :redeemed => false)
      
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
                itemset_hash["main_title"] = Item.with_deleted.find(order_item.main_id).name
                itemset_hash["side_id"] = order_item.side_id
                    itemset_hash["side_title"] = Item.with_deleted.find(order_item.side_id).name
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

      respond_to do |format|
        format.html
        format.csv do
          response.headers['Content-Type'] ||= 'text/csv'
          response.headers['Content-Disposition'] = "attachment; filename=dailyreport.csv"
          send_data csviy(@orders), :filename => "DailyReport.csv"
        end
      end
    
  end

  def csviy(orders)
    CSV.generate do |csv|
      column_headers = ["Order ID", "Customer Name", "Main", "Side", "Qty", "Amount", "Trx Time", "Redemption Time"]
      csv << column_headers
      orders.each do |order|
        
        item_sets_array = []
        order.order_items.each do |order_item|
          itemset_hash = {}
          itemset_hash["main_id"] = order_item.main_id
          itemset_hash["main_title"] = Item.with_deleted.find(order_item.main_id).name
          itemset_hash["side_id"] = order_item.side_id
          itemset_hash["side_title"] = Item.with_deleted.find(order_item.side_id).name
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
        end

        first_time = true
        item_sets_array.each do |set| 
          loaded_array = []
          if first_time
            loaded_array << order.id
            loaded_array << order.user.name
          else
            loaded_array << " "
            loaded_array << " "
          end
          loaded_array << set["main_title"]
          loaded_array << set["side_title"]
          loaded_array << set["quantity"]
          if first_time
            loaded_array << ActionController::Base.helpers.number_to_currency(order.amount)
            loaded_array << order.created_at 
            loaded_array << order.updated_at
          else

          end
          csv << loaded_array
          first_time = false
        end

        # csv << loaded_array
      end

    end
  end


end
