class CreateDeliveryLocations < ActiveRecord::Migration
  def change
    create_table :delivery_locations do |t|
      t.string :name
      t.datetime :delivery_timing
      t.integer :colony_id
      t.timestamps
    end
  end
end
