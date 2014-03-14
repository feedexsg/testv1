module Api
  
  class UsersController < Api::BaseController
    respond_to :json
    
    skip_filter :restrict_access, only: [:create]
    
    def create
      begin
        # @user = User.new(params[:user])
        user = User.new(user_params)
        generate_auth_key user
        if user.save
          @response = {success: true, success_message: "User has been saved successfully", user: user}
        else
          @response = {success: false, error_message: "Invalid user details", errors: user.errors}
        end
      rescue Exception => e
        @response = {success: false, error_message: "error processing request, please try again later!"}
        Rails.logger.error "Stacktrace: \n\t#{e.backtrace.join("\n\t")}"
      end
      respond_with @response.to_json, location: ""
    end
    
    def update
      begin
        auth_key = request.headers["X-Auth"]
        user = User.where(id: params[:id], auth_key: auth_key).first
        if user && params[:user].present?
          if user.update_attributes(user_params)
            @response = {success: true, success_message: "User has been updated successfully"}
          else 
            @response = {success: false, error_message: "Please fix the errors", errors: user.errors}
          end
        else
          @response = {success: false, error_message: "Either wrong combination of id and auth_token OR missing user parameters to update"}
        end
      rescue Exception => e
        @response = {success: false, error_message: "error processing request, please try again later!"}
        Rails.logger.error "Stacktrace: \n\t#{e.backtrace.join("\n\t")}"
      end
      render json: @response
    end

    def available_credits
      begin
        auth_key = request.headers["X-Auth"]
        user = User.where(id: params[:id], auth_key: auth_key).first
        if user
          @response = {success: true, available_credits: user.available_credits}
        else
          @response = {success: false, error_message: "Invalid User", errors: "Invalid user or user not found"}
        end
      rescue Exception => e
        @response = {success: false, error_message: "error processing request, please try again later!"}
        Rails.logger.error "Stacktrace: \n\t#{e.backtrace.join("\n\t")}"
      end
      render json: @response
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :mobile
                                   :colony_id, credits_attributes: [:amount, :source])
    end  
  
  end
    
end