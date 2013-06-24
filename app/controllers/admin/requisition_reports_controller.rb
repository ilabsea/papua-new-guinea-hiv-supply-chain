module Admin
	class RequisitionReportsController < Controller
		def index
			@requisition_reports = _site.requisition_reports.paginate(paginate_options)
		end

		def new
			@requisition_report = RequisitionReport.new
			_fill_attribute
		end

		def create
			@requisition_report = RequisitionReport.new params[:requisition_report]
			_fill_attribute
			if @requisition_report.save
				redirect_to admin_requisition_reports_path(), :notice => 'Requisition Report has been summitted successfully'
			else
				render :new
			end
		end

		def _fill_attribute
			@requisition_report.site = _site
			@user ||= current_user
			@requisition_report.user = @user 
		end

		def _site
			return @site if @site
			@site = current_user.site 
			return @site if @site
			@site = Site.find params[:site_id]
			@site
		end

		def import 
			
		end

	end

end