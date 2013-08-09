module Admin
  class DashboardsController < Controller
  	def index
  		if current_user.admin?
  		  redirect_to admin_settings_path()
  		elsif current_user.site?
  		  redirect_to admin_requisition_reports_path()
  		else  	
  		    @total_order_by_status = Order.total_by_status_date params[:start], params[:end]	
			if current_user.data_entry?	  
			  render :data_entry
			elsif current_user.reviewer?		
			  render :reviewer	
			elsif current_user.ams?	
			  @total_shipment_by_status = Shipment.total_shipment_by_status
			  render :ams			    		  			
			end
		end	
	end
  end
end