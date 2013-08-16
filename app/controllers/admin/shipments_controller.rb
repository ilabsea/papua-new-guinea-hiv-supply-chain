module Admin
  class ShipmentsController < Controller

    def index
      @shipments = Shipment
      @shipments = @shipments.where(["status =:status", :status => params[:type] ]) if params[:type]

      @shipments = Shipment.paginate(paginate_options)
    end 

    def new
      @order = Order.find params[:order_id]
      @shipment = @order.shipments.build()
      @app_title = "Create new shipment"	
    end


    def order
  	   # @orders = Order.includes(:order_lines, :site).approved.where("order_lines.shipment_status = 0")	
  	   # @order_lines = []

  	   # @sites = @orders.map{|order| [ order.site.name, order.site.id] }

  	   # @orders.each do |order|
  	   # 	@order_lines +=  order.order_lines
  	   # end
       # session[:shipment] = nil

       @shipment_session = ShipmentSession.new(session)
  	   @order_lines = OrderLine.items(params[:site_id]).not_shipped.paginate(paginate_options)
  	   @sites = []

  	   # pagination required
  	   # @order_lines.each do |order_line|
  	   # 	 site_item = [order_line.order.site.name, order_line.order.site.id ]
  	   # 	 @sites << site_item if !@sites.include?(site_item)
  	   # end

       @shipment = Shipment.new

  	   @orders = Order.includes(:site).approved
  	   @orders.each do |order|
		   site_item = [order.site.name, order.site.id ]
  	   	 @sites << site_item if !@sites.include?(site_item)
  	   end
    end

    def create_shipment
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
            sms_shipment = ShipmentSms.new(@shipment)
            sms_shipment.alert

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
      Shipment.bulk_update_status params[:status_shipment_id], params[:status]
      redirect_to admin_shipments_path, :notice => "Shipments' status have been updated successfully"
    end

    def show
      @app_title = "Shipment detail"
      @shipment = Shipment.includes(:shipment_lines => {:order_line => :commodity}).find params[:id]
    end

  end
end

