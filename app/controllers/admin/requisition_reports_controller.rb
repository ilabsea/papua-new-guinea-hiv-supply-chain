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
				if Order.create_from_requisition_report @requisition_report
				  redirect_to admin_requisition_reports_path, :notice => 'Order has been created successfully'
				else
				  redirect_to admin_requisition_reports_path, :error => 'Failed to import Order'	
				end
			else
				render :new
			end
		end

		def download
	     	@requisition_report = RequisitionReport.find params[:id]
	        send_file(@requisition_report.form.current_path , 
	                      :filename      =>  "template.xls",
	                      :type          =>  'application/xls',
	                      :disposition   =>  'attachment',
	                      :streaming     =>  true,
	                      :buffer_size   =>  '4096')
		end

		def destroy
			begin
				form = RequisitionReport.find params[:id]
				form.destroy
				redirect_to admin_requisition_reports_path, :notice => 'Requistion Form summitted has been deleted'
			rescue Exception => e
				redirect_to admin_requisition_reports_path, :error => e.message
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
			requisition_report = RequisitionReport.find params[:id]
			order = requisition_report.order
			order.destroy if order
			
			if Order.create_from_requisition_report requisition_report
			  redirect_to admin_orders_path, :notice => 'Order has been created successfully'
			else
			  redirect_to admin_requisition_reports_path, :error => 'Failed to import'	
			end
		end

		def _import_requisition_report requisition_report

		end

	end

end