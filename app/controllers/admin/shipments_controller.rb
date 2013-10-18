module Admin
  class ShipmentsController < Controller
    load_and_authorize_resource

    skip_authorize_resource :only => [:create_shipment]
    skip_load_resource :only => [:create_shipment]

    helper_method :order_params

    def order_fields
      @order_fields ||= 
      [ 
        'sites.name' , 'shipments.consignment_number', 'shipments.id', 'shipments.status', 'shipments.shipment_date', 'shipments.site_messages_count',
        'shipments.sms_logs_count' ,'shipments.last_notified_date', 'shipments.received_date', 'shipments.lost_date','shipments.cost', 'shipments.carton'
      ]
    end

    def order_params
      @order_params = @order_params || {
        :field => ( order_fields.include?(params[:field]) ? params[:field] : 'shipments.id' ),
        :order => ( [ 'asc', 'desc'].include?(params[:order]) ? params[:order] : 'desc' )
      }
    end

    def index
      @shipments = Shipment.includes(:sites).unscoped.joins("LEFT OUTER JOIN sites ON sites.id = shipments.site_id").order( "#{order_params[:field]} #{order_params[:order]}" )
      @shipments = @shipments.where(["status =:status", :status => params[:type] ]) if params[:type]
      @shipments = @shipments.paginate(paginate_options)
    end 

    def new
      @order = Order.find params[:order_id]
      @shipment = @order.shipments.build()
      @app_title = "Create new shipment"	
    end

    def order
       @shipment_session = ShipmentSession.new(session)
  	   @order_lines = OrderLine.items(params[:site_id]).data_filled.not_shipped.paginate(paginate_options)
  	   @sites = []

       @shipment = Shipment.new

  	   @orders = Order.includes(:site).approved
  	   @orders.each do |order|
		   site_item = [order.site.name, order.site.id ]
  	   	 @sites << site_item if !@sites.include?(site_item)
  	   end
    end

    def create_shipment
      authorize! :create_shipment, :shipments

      @shipment = Shipment.new(params[:shipment])
      response = {}
      shipment_session = ShipmentSession.new session

      if(shipment_session.empty?)
        response[:status] = :failed
        response[:message] = 'No item selected' 
      else
         order_line_id    = shipment_session.shipment.first[0]
         order_line       = OrderLine.includes(:order => :site).find order_line_id

         @shipment.user   = current_user
         @shipment.site   = order_line.order.site
         @shipment.order  = order_line.order
         @shipment.status = Shipment::STATUS_IN_PROGRESS
 
         if @shipment.create_shipment(shipment_session)
            shipment_sms = ShipmentSms.new(@shipment)
            shipment_sms.alert

            shipment_session.clear
            response[:status] = :success
            response[:message] = 'Shipment has been created' 
         else
            response[:status] = :failed
            response[:message] = @shipment.errors.full_messages[0]
         end
      end
      render :json => response
    end

    def remove_session
      order_line_id = params[:order_line_id]
      shipment_session = ShipmentSession.new session
      shipment_session.delete order_line_id
      render :json => {:status => :success, :session => shipment_session.shipment}
    end

    def add_session

      @shipment_session = ShipmentSession.new(session)
      options = params.slice(:order_line_id, :quantity, :remark)

      shipment_line_session = ShipmentLineSession.new(options)
      shipment_line_session.set_container @shipment_session

      if(shipment_line_session.valid?)
        @shipment_session.add shipment_line_session
        render :json => { :status => :success}
      else     
        render :json => { :status => :failed, :error => shipment_line_session.errors.full_messages[0] }  
      end 
    end

    def mark_status
      if Shipment.bulk_update_status params[:status_shipment_id], params[:status]
        redirect_to request.referer, :notice => "Shipments' status have been updated successfully"
      else
        redirect_to request.referer, :notice => "Some shipments status could not be updated"
      end
    end

    def show
      @app_title = "Shipment detail"
      @shipment = Shipment.includes(:shipment_lines => {:order_line => :commodity}).find params[:id]
      @shipment_lines = @shipment.shipment_lines.paginate paginate_options
    end

    def download
      time =Time.now.strftime("%Y-%m-%d %H:%m:%S_")

      file_name =  "#{Rails.root}/public/data/#{time}shipment.csv"
         
      Export.shipment file_name, params[:type]
      send_file(file_name , :filename      =>  File.basename(file_name),
                            :type          =>  'application/xls',
                            :disposition   =>  'attachment',
                            :streaming     =>  true,
                            :buffer_size   =>  '4096')
    end

    def update_cost
      id   = params[:id]
      cost = params[:cost]

      shipment = Shipment.find id
      shipment.cost = cost

      response = {}
      
      if shipment.save
        response[:status] = :ok
        response[:message] = "Shipment cost has been updated to cost: "  + cost

      else
        response[:status] = :failed
        response[:message] = shipment.errors.full_messages[0]

      end

      render :json => response

    end

  end
end

