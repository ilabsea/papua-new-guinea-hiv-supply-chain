module Admin
 class OrdersController < Controller
   load_and_authorize_resource

   skip_load_resource :only => [:tab_order_line] # must skip loading resource by cancan
   skip_authorize_resource :only => [:tab_order_line] 


   def index
     @date_start = params[:date_start] 
     @date_end   = params[:date_end]
     @orders = Order.includes(:site, :user_data_entry, :review_user)

     if current_user.reviewer?
        @orders = @orders.where(['status != ?', Order::ORDER_STATUS_PENDING ])
     end

     if(!params[:type].blank?)
       @orders = @orders.of_status(params[:type])
     end
     
     @orders = @orders.of_user(current_user).in_between(@date_start, @date_end)
     @orders = @orders.paginate(paginate_options)

   end

   def review
     @type = params[:type] || CommodityCategory::TYPES_DRUG 
     @order = _order
   end

   def edit
     @order = _order
     _build_tab @order, @order.site
   end

   def update
     @order = _order
     @order.user_data_entry = current_user
     if current_user.data_entry?
       @order.status = Order::ORDER_STATUS_TO_BE_REVIEWED
     end

     if @order.update_attributes params[:order]
       @order.update_approval if current_user.data_entry_and_reviewer?
       redirect_to admin_orders_path, :notice => 'Order has been updated succesfully'
     else
       render :edit
     end
   end

   def destroy
     begin
     @order = Order.find params[:id]

     @order.requisition_report.destroy
     @order.destroy

     redirect_to admin_orders_path, :notice => 'Order has been deleted succesfully'
     rescue Exception => e
       redirect_to admin_orders_path, :error =>  e.message
     end  
   end

   def export
     file =  "#{Rails.root}/public/data/orders.csv"
     Export.order file, params[:type]
     send_file(file ,
              :filename      =>  "orders.csv",
              :type          =>  'text/csv',
              :disposition   =>  'attachment',
              :streaming     =>  true,
              :buffer_size   =>  '4096')
   end

   # don't refer me coz am private
   private

   def _order
     @order ||= Order.includes(:order_lines => :commodity).find params[:id]  
   end

   def _build_tab order, site
     _build_commodity_order_line order, site
   end

   def _build_commodity_order_line order, site
     existing_commodities = order.order_lines.map do |order_line| 
       #order_line.arv_type = order_line.commodity.commodity_category.com_type 
       # order_line.consumption_per_client_per_month = order_line.commodity.consumption_per_client_unit
       order_line.commodity
     end 

     non_existing_commodities = Commodity.order('name asc').includes(:commodity_category).all.select{|commodity| !existing_commodities.include?(commodity) }
     non_existing_commodities.each do |commodity| 
       order.order_lines.build :commodity    => commodity, 
                     :site         => site,
                     :arv_type    => commodity.commodity_category.com_type
     end
   end
  end
end