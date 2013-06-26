module Admin
 class OrdersController < Controller
 	def index
 		@orders = Order.order('id desc').paginate(paginate_options)
 	end

 	def destroy
 		begin
 			@order = Order.find params[:id]
 			@order.destroy
 			redirect_to admin_orders_path, :notice => 'Order has been destroy succesfully'
 		rescue Exception => e
 			redirect_to admin_orders_path, :error =>  e.message
 		end	
 	end
 end
end