module Admin
  class OrderLinesController < Controller
  	def index
  		@order = Order.find params[:order_id]
  		@order_lines = @order.order_lines.paginate(paginate_options)
  		@app_title = "Order lines"
  	end
  end

end