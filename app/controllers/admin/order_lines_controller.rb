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
  end

end