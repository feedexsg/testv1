class AddOperationFieldsToMenus < ActiveRecord::Migration
  def change
    change_table :menus do |t|
      t.boolean :status, default: false
      t.datetime :start_time
      t.datetime :end_time
    end
    change_table :items_menus do |t|
      t.integer :quantity
    end
  end
end
