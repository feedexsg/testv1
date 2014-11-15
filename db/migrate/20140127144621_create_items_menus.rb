class CreateItemsMenus < ActiveRecord::Migration
  def change
    create_table :items_menus do |t|
      t.integer :item_id
      t.integer :menu_id
      t.datetime :availability_time
      t.timestamps
    end
  end
end
