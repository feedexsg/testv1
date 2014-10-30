class MenusController < ApplicationController
  layout false
  include CurrentCart
  include SessionsHelper
  before_action :set_cart, only: [:index]
  before_action :signed_in_user, only: [:index]

  def index
    Rails.logger.info "*****  User is using...."
    Rails.logger.info browser.to_s
    Rails.logger.info "*****"
    if browser.tablet?
      Rails.logger.info "Browser is tablet"
    elsif browser.mobile?
      Rails.logger.info "Browser is mobile"
    else
      Rails.logger.info "Browser is desktop"
    end

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

      main_items_qty = []
      @main_items.each do |m|
        main_items_qty << m.items_menus.last.quantity
      end
      gon.main_items_qty = main_items_qty

      side_items_qty = []
      @side_items.each do |s|
        side_items_qty << s.items_menus.last.quantity
      end
      gon.side_items_qty = side_items_qty

      # Cart for Menu Desktop
      remember_token = User.digest(cookies[:remember_token])
      @current_user ||= User.find_by(remember_token: remember_token)
      @total_price = 0.0
      @cart.line_items.each do |item|
        if Item.find(item.side_id).price == 0 
          @total_price += Item.find(item.main)id).price
        else 
        @total_price += 0.9 * Item.find(item.main_id).price 
        @total_price += 0.9 * Item.find(item.side_id).price
      end

      @item_sets = []
      @cart.line_items.each do |i|
        item_hash = {}
        item_hash[:main_id] = i.main_id
        item_hash[:side_id] = i.side_id
        @item_sets << item_hash
      end

      # Menu for Menu Desktop
      @credits = @current_user.total_credits
  end

  private
  def signed_in_user
    redirect_to signin_url, notice: "Please sign in." unless signed_in?
  end
  
end