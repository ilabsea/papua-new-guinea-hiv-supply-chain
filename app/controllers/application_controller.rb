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
  
  def paginate_options
    { :page => params[:page] || 1 , :per_page => 15 } 
  end

  def after_sign_out_path_for(resource_or_scope)
    sign_in_path
  end

  def after_sign_in_path_for(resource_or_scope)
    admin_root_path()
  end
  
  
end
