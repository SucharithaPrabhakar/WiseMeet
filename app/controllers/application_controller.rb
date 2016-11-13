require "application_responder"
class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    #Uncomment later
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

 private 
   def logged_in_user
    unless user_signed_in?
      #store_location
      flash[:danger] = "Please log in."
      #redirect_to new_user_session_url
      redirect_to login_url
    end 
  end  
end
