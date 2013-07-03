module Admin
 class OrdersController < Controller
 	def index
 		@orders = Order.of(current_user).paginate(paginate_options) 
 	end

 	def new 
 		@order = Order.new
 		@commodities_kit = Commodity.of_kit
 		@commodities_drug = Commodity.of_drug

 		@commodities_kit.each do |commodity|
 			@order.order_lines.build(:commodity => commodity)
 		end

 		@commodities_drug.each do |commodity|
 			@order.order_lines.build(:commodity => commodity)
 		end
 	end

 	def create
 		raise 'Unable to create order. Only data entry user is able to create order' if !current_user.data_entry?
 		@order = Order.new params[:order].slice(:order_date, :date_submittion)
 		
 		@order.user_data_entry = current_user
 		@order.user_place_order_id = params[:order][:user_place_order] if !params[:order][:user_place_order].blank? 
 		@order.site_id = params[:order][:site]

 		@order.status = Order::ORDER_STATUS_PENDING
 		@order.is_requisition_form = false

 		if @order.save
 		 	redirect_to admin_orders_path, :notice => 'Order has been created'	
 		else
 			render :new
 		end
 	end

 	def destroy
 		begin
 			@order = Order.find params[:id]
 			@order.destroy
 			redirect_to admin_orders_path, :notice => 'Order has been deleted succesfully'
 		rescue Exception => e
 			redirect_to admin_orders_path, :error =>  e.message
 		end	
 	end
 end
end