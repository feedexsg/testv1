module Api
  
  class CreditsController < Api::BaseController
    respond_to :json
    
    def create
      begin
        credit = Credit.new(params[:credit].merge({user_id: @current_user.id}))
        if credit.save
          @response = {success: true, success_message: "Credit record created", credit: credit}
        else
          @response = {success: false, error_message: "Invalid credits", errors: credit.errors}
        end
      rescue Exception => e
        @response = {success: false, error_message: "error processing request, please try again later!"}
        Rails.logger.error "Credits not added. ERROR => #{e.message}"
      end
      render json: @response.to_json
    end

  end

  private
  def credit_params
    params[:credit].permit(:amount, :user_id, :source)
  end
    
end
