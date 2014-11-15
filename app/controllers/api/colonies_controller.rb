module Api
  
  class ColoniesController < Api::BaseController
    respond_to :json

    skip_before_filter :restrict_access

    def index
      @colonies = Colony.all
      respond_with(colonies: @colonies)
    end

  end

end
