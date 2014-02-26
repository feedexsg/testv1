module Api
  
  class SessionsController < Api::BaseController
    respond_to :json
    
    skip_filter :restrict_access, only: [:create]
    
    def create
      begin
        user = User.where(email: params[:email]).first
        if user && user.authenticate(params[:password])
          generate_auth_key(user)
          if user.save!
            response = {success: true, success_message:"#{user.name} logged in successfully!", auth_key: user.auth_key, user_id: user.id}
          else
            response = {success: false, error_message: "error processing request, please try again later!"}
          end
        else
          response = {success: false, error_message: "Incorrect username/password combination."}
        end
      rescue Exception => e
        response = {success: false, error_message: "error processing request, please try again later!"}
        Rails.logger.error "Stacktrace: \n\t#{e.backtrace.join("\n\t")}"
      end
      respond_with response.to_json, location: ""
    end
    

    def destroy
      begin
        auth_key = request.headers["X-Auth"]
        user = User.where(id: params[:id], auth_key: auth_key).first
        if user
          if user.update_attributes(auth_key: nil)
            response = {success: true, success_message: "#{user.name} logged out successfully!"}
          else
            response = {success: false, error_message: "error processing request, please try again later!"}
          end
        else
          response = {success: false, error_message: "Wrong combination of id and token"}
        end
      rescue Exception => e
        response = {success: false, error_message: "error processing request, please try again later!"}
        Rails.logger.error "Stacktrace: \n\t#{e.backtrace.join("\n\t")}"
      end
      render json: response
    end
    
  
  end
    
end