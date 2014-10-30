class CartsController < ApplicationController
  layout false
  include SessionsHelper
  before_action :set_cart, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user, only: [:index, :show]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart

  # GET /carts
  # GET /carts.json
  def index
    @carts = Cart.all
  end

  # GET /carts/1
  # GET /carts/1.json
  def show
    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
    @total_price = 0.0
    @cart.line_items.each do |item|
      if Item.find(item.side_id).price == 0 
          @total_price += Item.find(item.main_id).price
        else 
        @total_price += 0.9 * Item.find(item.main_id).price 
        @total_price += 0.9 * Item.find(item.side_id).price
      end
    end

    @item_sets = []
    @cart.line_items.each do |i|
      item_hash = {}
      item_hash[:main_id] = i.main_id
      item_hash[:side_id] = i.side_id
      @item_sets << item_hash
    end

  end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts
  # POST /carts.json
  def create
    @cart = Cart.new(cart_params)

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: 'Cart was successfully created.' }
        format.json { render action: 'show', status: :created, location: @cart }
      else
        format.html { render action: 'new' }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carts/1
  # PATCH/PUT /carts/1.json
  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @cart.destroy
    respond_to do |format|
      if browser.tablet?
        format.html { redirect_to carts_url }
      elsif browser.mobile?
        format.html { redirect_to carts_url }
      else
        format.html { redirect_to menus_url }
      end
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cart_params
      params[:cart]
    end

    def invalid_cart
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to root_url, notice: 'Invalid cart'
    end

    def signed_in_user
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end
end
