class AddMainIdAndSideIdToOrderItems < ActiveRecord::Migration
  def change
  	remove_column :order_items, :items_id, :references
  	remove_column :order_items, :amount, :integer
    add_column :order_items, :main_id, :integer
    add_column :order_items, :side_id, :integer
  end
end
