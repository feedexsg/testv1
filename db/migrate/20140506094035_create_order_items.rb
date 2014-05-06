class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :order, index: true
      t.references :items, index: true
      t.integer :amount

      t.timestamps
    end
  end
end
