class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_manager

  PER_PAGE = 10
  
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
    { :page =>  page_number , :per_page => PER_PAGE } 
  end

  def current_entries
    PER_PAGE * (page_number.to_i - 1) + 1
  end

  def require_paginate_for? records
    records.total_entries > PER_PAGE
  end

  def page_number 
    params[:page] || 1
  end

  def after_sign_out_path_for(resource_or_scope)
    sign_in_path
  end

  def after_sign_in_path_for(resource_or_scope)
    admin_root_path()
  end

  helper_method :current_entries, :require_paginate_for?
  
  
end
