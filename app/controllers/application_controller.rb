class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  # Devise parameter sanitization
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  # Include Pagy helpers
  include Pagy::Backend
  
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :name, :bio, :avatar])
  end
  
  # Redirect to snippets after sign in
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || snippets_path
  end
end
