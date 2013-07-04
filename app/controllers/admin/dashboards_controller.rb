module Admin
  class DashboardsController < Controller
  	def index
  		if current_user.admin?
  			redirect_to admin_settings_path()
			elsif current_user.data_entry?
				redirect_to admin_orders_path()				
			end
		end
	end
end