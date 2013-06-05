class ApplicationController < ActionController::Base
  protect_from_forgery
 
  layout :layout_manager
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end
  
  def layout_manager
    
    if devise_controller? && resource_name == :user && action_name == "new"
       "login"
    else
       "application"
    end
  end
  
  
end
