module Admin
  class DashboardsController < Controller
  	def index
  		if current_user.admin?
  		  redirect_to admin_settings_path()
		elsif current_user.data_entry?
		  @total_order_by_status = Order.total_by_status	
		  render :data_entry
		elsif current_user.reviewer?
		  @total_order_by_status = Order.total_by_status		
		  render :reviewer	
		else
		  redirect_to admin_requisition_reports_path()			
		end
	end

  end
end