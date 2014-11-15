class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.decimal :amount, precision: 10, scale: 2
      t.datetime :delivery_time
      t.timestamps
    end
  end
end
