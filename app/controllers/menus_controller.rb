class MenusController < ApplicationController
  layout false
  include CurrentCart
  before_action :set_cart, only: [:index]
  def index
  	@menu = Menu.last # Menu.current
  	@main_items = @menu.items.main
      main_items_hash = ActiveSupport::JSON.decode(@main_items.to_json)
      main_items = main_items_hash.collect do |item_hash|
        item = Item.find_by_id(item_hash["id"])
        item_hash.slice!("image_file_name", "image_content_type", "image_file_size", "image_updated_at").merge!({"original_url" => item.image}) if item
      end.compact

      @side_items = @menu.items.side
      side_items_hash = ActiveSupport::JSON.decode(@side_items.to_json)
      side_items = side_items_hash.collect do |item_hash|
        item = Item.find_by_id(item_hash["id"])
        item_hash.slice!("image_file_name", "image_content_type", "image_file_size", "image_updated_at").merge!({"original_url" => item.image}) if item
      end.compact

      gon.main_items = @main_items
      gon.side_items = @side_items
      gon.cart_number = @cart.line_items.count
  end
  
end