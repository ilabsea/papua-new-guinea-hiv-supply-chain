module Admin
  class OrderLinesController < Controller
  	def index
  		@order = Order.find params[:order_id]
  		if params[:type] == CommodityCategory::TYPES_DRUG
  			@order_lines = @order.order_lines.drug.paginate(paginate_options)
  		else params[:type] == CommodityCategory::TYPES_KIT
  			@order_lines = @order.order_lines.kit.paginate(paginate_options)	
  		end		
  		@app_title = "Order lines"
  	end

    def approve
      @order = Order.find(params[:order_id])
      @order_line = OrderLine.find(params[:id])

      @order_line.status = OrderLine::STATUS_APPROVED
      @order_line.user_reviewer_note = params[:reviewer_note]
      @order_line.save

      @order.review_user = current_user
      @order.update_status_accepted
      @order.review_date = Time.now
      @order.save

      redirect_to review_admin_order_path(@order, :anchor =>@order_line.id, :type => @order_line.arv_type), 
          :notice => "Order for  commodity: <b> #{@order_line.commodity.name}</b> has been approved"


    end

    def reject
      @order = Order.find(params[:order_id])
      @order_line = @order.order_lines.find(params[:id])

      @order_line.status = OrderLine::STATUS_REJECTED
      @order_line.user_reviewer_note = params[:reviewer_note]

      @order_line.save
      
      @order.status = Order::ORDER_STATUS_TO_BE_REVISED
      @order.review_user = current_user
      @order.review_date = Time.now
      @order.save
      # redirect_to admin_orders_path(:type => Order::ORDER_STATUS_TO_BE_REVISED),
      redirect_to review_admin_order_path(@order,:anchor =>@order_line.id, :type => @order_line.arv_type ),
          :notice => "Order for Site : <b> #{@order.site.name}</b> has been rejected"
    end

  end

end