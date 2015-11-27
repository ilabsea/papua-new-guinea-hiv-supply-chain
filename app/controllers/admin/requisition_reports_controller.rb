module Admin
  class RequisitionReportsController < Controller
    before_filter :load_requistion_reports, :only => :index #overide load_resource
    load_and_authorize_resource
    skip_authorize_resource :only => [:download]

    def index
      load_requistion_reports
    end

    def new
      # @requisition_report = RequisitionReport.new
      fill_attribute
    end

    def create
      @requisition_report = RequisitionReport.new params[:requisition_report]
      fill_attribute

      if @requisition_report.save_nested_order
        redirect_to admin_requisition_reports_path, :notice => 'Order has been created successfully'
      else
        flash.now[:alert] = @requisition_report.errors.full_messages.join("<br />")
        render :new
      end
    end

    def download
         @requisition_report = RequisitionReport.find params[:id]
          send_file(@requisition_report.form.current_path , 
                        :filename      =>  File.basename(@requisition_report.form.current_path) ,
                        :type          =>  'application/xls',
                        :disposition   =>  'attachment',
                        :streaming     =>  true,
                        :buffer_size   =>  '4096')
    end

    def destroy
      begin
        @requisition_report = RequisitionReport.find params[:id]
        @requisition_report.destroy
        redirect_to admin_requisition_reports_path, :notice => 'Requistion Form summitted has been deleted'
      rescue Exception => e
        redirect_to admin_requisition_reports_path, :error => e.message
      end
    end

    def fill_attribute
      @requisition_report.site = current_user.site
      @requisition_report.user = current_user
    end

    def import 
      # @requisition_report = RequisitionReport.find params[:id]
      order = @requisition_report.order
      order.destroy if order
      
      if Order.create_from_requisition_report @requisition_report
        redirect_to admin_orders_path, :notice => 'Order has been created successfully'
      else
        redirect_to admin_requisition_reports_path, :error => 'Failed to import'
      end
    end

    def load_requistion_reports
      if current_user.site?
        @requisition_reports = current_user.site.requisition_reports.paginate(paginate_options)
      elsif current_user.admin?
        @requisition_reports = RequisitionReport.paginate(paginate_options)  
      end
    end

  end

end