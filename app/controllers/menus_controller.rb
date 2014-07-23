class MenusController < ApplicationController
  layout false
  include CurrentCart
  include SessionsHelper
  before_action :set_cart, only: [:index]
  before_action :signed_in_user, only: [:index]
  before_filter :detect_browser

  def index
    Rails.logger.info "******************@**@**@*  User is using...."
    Rails.logger.info @browser
    Rails.logger.info "*****"
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

  private
  def signed_in_user
    redirect_to signin_url, notice: "Please sign in." unless signed_in?
  end

  MOBILE_BROWSERS = ["android", "ipod", "opera mini", "blackberry", "palm","hiptop","avantgo","plucker", "xiino","blazer","elaine", "windows ce; ppc;", "windows ce; smartphone;","windows ce; iemobile", "up.browser","up.link","mmp","symbian","smartphone", "midp","wap","vodafone","o2","pocket","kindle", "mobile","pda","psp","treo"]

  def detect_browser
    @browser = "desktop"
    agent = request.headers["HTTP_USER_AGENT"].downcase
    MOBILE_BROWSERS.each do |m|
      @browser =  "mobile_application" if agent.match(m)
      return
    end
  end
  
end