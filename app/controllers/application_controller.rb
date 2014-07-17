class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #before_filter :build_temporary_cart
  include SessionsHelper
  
  #def build_temporary_cart
  #	session[:temporary_shopping_cart] = []
  #end
end
