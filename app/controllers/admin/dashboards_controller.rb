module Admin
  class DashboardsController < Controller
  	def index
  		if current_user.admin?
  			redirect_to admin_settings_path()
		elsif current_user.data_entry?
			render :data_entry
		else
			redirect_to admin_requisition_reports_path()			
		end
	end

	def data_entry

	end
  end
end