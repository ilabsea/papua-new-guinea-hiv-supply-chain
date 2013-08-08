module Admin
  class ShipmentsController < Controller
    def index
      @order = Order.find params[:order_id]	
      		

      ents = @order.shipments.paginate(paginate_options)
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

  	   @orders = Order.includes(:site).approved
  	   @orders.each do |order|
		 site_item = [order.site.name, order.site.id ]
  	   	 @sites << site_item if !@sites.include?(site_item)
  	   end



    end

  end
end

