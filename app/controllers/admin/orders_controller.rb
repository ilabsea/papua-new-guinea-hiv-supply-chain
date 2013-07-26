module Admin
 class OrdersController < Controller
 	def index
 		@date_start = params[:date_start] 
 		@date_end   = params[:date_end]
 		@orders = Order.includes(:site, :user_data_entry)

 		if(!params[:type].blank?)
 		  @orders = @orders.of_status(params[:type])
 		end
 		
 		@orders = @orders.of_user(current_user).in_between(@date_start, @date_end)
 		@orders = @orders.paginate(paginate_options) 
 		@app_title = 'List of Orders'
 	end

 	def new 
 		@order = Order.new(:status => Order::ORDER_STATUS_PENDING)
 		_build_commodity_order_line(@order)		
 		@app_title = 'Create Order'
 	end

 	def tab_order_line
 		# must eager load order_lines, otherwise each orline from order.order_lines will go to sql query
 		@order 			  =  params[:id].blank? ? Order.new() : Order.includes(:order_lines).find(params[:id])
 		@order.site 	  =  Site.find params[:site_id]
 		@order.order_date =  params[:order_date]
 		_build_tab(@order)	
 		render :layout => false
 	end

 	def create
 		raise 'Unable to create order. Only data entry user is able to create order' if !current_user.data_entry?
 		@order = Order.new params[:order]
 		@order.user_data_entry = current_user
 		@order.status = Order::ORDER_STATUS_TO_BE_REVIEWED
 		@order.is_requisition_form = false

 		if @order.save
 		  redirect_to admin_orders_path, :notice => 'Order has been created'	
 		else
 		  render :new
 		end
 	end

 	def review
 	  @type = params[:type] || CommodityCategory::TYPES_DRUG 
 	  @order = Order.includes(:order_lines => :commodity).find params[:id]	
 	end

 	def edit
 	  @order = Order.find params[:id]
 	  _build_tab @order
 	  @app_title = 'Edit order, Site :' + @order.site.name
 	end

 	def update
 	  @order = Order.find params[:id]
 	  @order.user_data_entry = current_user if current_user.data_entry?
 	  @order.status = Order::ORDER_STATUS_TO_BE_REVIEWED

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

 	def export
 		file =  "#{Rails.root}/public/data/orders.csv"
 		ExportOrder.as_csv file
 		send_file(file , 
	                      :filename      =>  "orders.csv",
	                      :type          =>  'text/csv',
	                      :disposition   =>  'attachment',
	                      :streaming     =>  true,
	                      :buffer_size   =>  '4096')
 	end

 	# don't refer me coz am private
 	private

 	def _build_tab order
 		_build_commodity_order_line order
 		order.order_lines_calculation
 	end

 	def _build_commodity_order_line order
 	  existing_commodities = order.order_lines.map do |order_line| 
 	  	order_line.arv_type = order_line.commodity.commodity_category.com_type
 	  	order_line.consumption_per_client_per_month = order_line.commodity.consumption_per_client_unit 
 	  	order_line.commodity
 	  end 
 	  commodities = Commodity.order('name asc').includes(:commodity_category).all.select{|commodity| !existing_commodities.include?(commodity) }

 	  commodities.each do |commodity| 
 	    order.order_lines.build :commodity_id  => commodity.id, 
 		  						  :arv_type		 => commodity.commodity_category.com_type,
 		  						  :consumption_per_client_per_month => commodity.consumption_per_client_unit  
 	  end
 	end
  end
end