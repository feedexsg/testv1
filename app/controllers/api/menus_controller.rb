module Api
  
  class MenusController < Api::BaseController
    respond_to :json

    skip_before_filter :restrict_access
    
    def index
      @menu = Menu.current
      @main_items = @menu.items.main
      main_items_hash = ActiveSupport::JSON.decode(@main_items.to_json)
      main_items = main_items_hash.collect do |item_hash|
        item = Item.find_by_id(item_hash["id"])
        item_hash.slice!("id", "name", "sku", "price", "category_id", "vendor_id").merge!({"original_url" => item.image}) if item
      end.compact
      @side_items = @menu.items.side
      side_items_hash = ActiveSupport::JSON.decode(@side_items.to_json)
      side_items = side_items_hash.collect do |item_hash|
        item = Item.find_by_id(item_hash["id"])
        item_hash.slice!("id", "name", "sku", "price", "category_id", "vendor_id").merge!({"original_url" => item.image}) if item
      end.compact

      respond_with(menu: @menu, main_items: main_items, side_items: side_items)
    end
  end
    
end
