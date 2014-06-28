class UsersController < ApplicationController
  layout false

  def new
    @user = User.new
  end

  def create

  end
  
end
