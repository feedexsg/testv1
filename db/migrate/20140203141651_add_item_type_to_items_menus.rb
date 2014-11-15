class AddItemTypeToItemsMenus < ActiveRecord::Migration
  def change
    add_column :items_menus, :item_type, :string
  end
end
