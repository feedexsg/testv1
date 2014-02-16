module Api
  
  class CreditsController < Api::BaseController
    respond_to :json
    
    def create
      begin
        credit = Credit.new(params[:credit])
        if credit.save
          @response = {success: true, success_message: "Credit record created", credit: credit}
        else
          @response = {success: false, error_message: "Invalid credits", errors: credit.errors}
        end
      rescue Exception => e
        @response = {success: false, error_message: "error processing request, please try again later!"}
        Rails.logger.error "Stacktrace: \n\t#{e.backtrace.join("\n\t")}"
      end
      respond_with @response.to_json
    end

  end
    
end
