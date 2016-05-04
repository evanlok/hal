module Api::V1
  class BaseController < ActionController::Base
    skip_before_action :verify_authenticity_token

    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    protected

    def not_found(exception)
      render json: { errors: [exception.message] }, status: :not_found
    end
  end
end
