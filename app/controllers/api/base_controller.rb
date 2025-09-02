class Api::BaseController < ActionController::API
  include Pagy::Backend
  
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  
  private
  
  def not_found
    render json: { error: 'Resource not found' }, status: :not_found
  end
end