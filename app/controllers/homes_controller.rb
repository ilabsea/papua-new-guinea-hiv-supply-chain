class HomesController < ApplicationController
  
  before_filter :authenticate_user! , :except => [:index]
  
  def index
    redirect_to admin_root_path()
  end
  
end