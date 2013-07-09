module Admin
 class OrdersController < Controller
 	def index
 		@date_start = params[:date_start] 
 		@date_end   = params[:date_end]
 		@orders = Order.includes(:site, :user_data_entry).of(current_user).in_between(@date_start, @date_end).paginate(paginate_options) 
 		@app_title = 'List of Orders'
 	end

 	def new 
 		@order = Order.new
 		_build_commodity_order_line(@order)		
 		@app_title = 'Create Order'
 	end

 	def tab_order_line
 		@order = Order.new
 		@surv_site = SurvSite.find_surv params[:site_id], params[:date]
 		_build_commodity_order_line(@order)	
 		
 	end

 	def create
 		raise 'Unable to create order. Only data entry user is able to create order' if !current_user.data_entry?
 		@order = Order.new params[:order]
 		@order.user_data_entry = current_user
 		@order.status = Order::ORDER_STATUS_PENDING
 		@order.is_requisition_form = false

 		if @order.save
 		 	redirect_to admin_orders_path, :notice => 'Order has been created'	
 		else
 			render :new
 		end
 	end

 	def edit
 		@order = Order.find params[:id]
 		_build_commodity_order_line @order
 		@app_title = 'Edit order, Site :' + @order.site.name
 	end

 	def update
 		@order = Order.find params[:id]
 		@order.user_data_entry = current_user if current_user.data_entry?

 		if @order.update_attributes params[:order]
 			redirect_to admin_orders_path, :notice => 'Order has been updated succesfully'
 		else
 			render :edit
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

 	# don't refer me coz am private
 	private
 	def _build_commodity_order_line order
 		existing_commodities = order.order_lines.map{|order_line| order_line.commodity}
 		commodities = Commodity.includes(:commodity_category).all.select{|commodity| !existing_commodities.include?(commodity) }


 		order.order_lines.each do |order_line|
 			order_line.quantity_system_calculation = ''
 			order_line.quantity_suggested = ''
 		end

 		commodities.each do |commodity|
 			order.order_lines.build(:commodity_id  => commodity.id, 
 									:quantity_system_calculation => '',
 									:quantity_suggested => '' ,
 									:arv_type 	=> commodity.commodity_category.com_type)
 		end
 	end
 end
end