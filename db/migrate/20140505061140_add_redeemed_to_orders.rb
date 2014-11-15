class AddRedeemedToOrders < ActiveRecord::Migration
  def change
  	add_column :orders, :redeemed, :boolean, :default => false
  end
end
