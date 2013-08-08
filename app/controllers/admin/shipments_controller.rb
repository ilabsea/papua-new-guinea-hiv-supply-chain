module Admin
  class ShipmentsController < Controller

    helper_method :session_shipment_from_order_line
    def index
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


  	   @order_lines = OrderLine.items(params[:site_id]).paginate(paginate_options)
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
      #if no item then error
      if(session[:shipment].nil? || session[:shipment].size == 0 )
        response[:status] = :failed
        response[:message] = 'No item selected' 
      #create shipment  
      else
         session_shipment = session[:shipment].first
         order_line = session_shipment.order_line
         @shipment.user = current_user
         @shipment.site = order_line.order.site
         @shipment.order = order_line.order

         if @shipment.create_shipment(session[:shipment])
           response[:status] = :success
           response[:message] = 'Shipment has been created' 
           #clean up session after successfully created
           @shipment.update_order_lines
           session[:shipment] = nil
         else
          response[:status] = :failed
          response[:message] = @shipment.errors.full_messages[0]
         end
      end
      render :json => response
    end

    def add_session

      options = params.slice(:order_line_id, :quantity, :remark)
      session_shipment = SessionShipment.new(options)
      response = {}

      if(session_shipment.valid?)

        # no session create
        if(session[:shipment].nil?)
          session[:shipment] = [ session_shipment ]
          response = { :status => :success}
        #validate if shipment line not in the same orderßß  
        else
          
          order_lines_id = session[:shipment].map{|item| item.order_line_id}
          order_lines = OrderLine.includes(:order).find order_lines_id

          order_line = session_shipment.order_line
          diff = order_lines.select{|item| item.order.id != order_line.order.id }
          if diff.size >0
            response = { :status => :failed, :error => 'Can not make shipment of different order'}

          #validate if shipment line is alreay in the session
          else
            
            search = session[:shipment].select{|shipment|  shipment.order_line_id == session_shipment.order_line_id}.first
            #not in the session yet then add it
            if(search.nil?)
              session[:shipment] << session_shipment  

            #already exist then update it  
            else
              session[:shipment].delete(search)
              session[:shipment] << session_shipment
            end  
            response = { :status => :success}  
          end
        end  
        
      else
        response = { :status => :failed, :error => session_shipment.errors.full_messages[0] }
      end
      render :json => response

    end


    def session_shipment_from_order_line order_line_id

      if session[:shipment]
        session[:shipment].each do |line|
          return line if(line.order_line_id.to_i == order_line_id.to_i)
        end
      end
      nil
    end

  end
end

