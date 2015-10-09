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
     load_order
   end

   def edit
     load_order
     build_commodity_order_line @order, @order.site
   end

   def tab_order_line
     @site  = Site.find(params[:site_id])
     @order = Order.new(site: @site, order_date: params[:order_date])
     build_commodity_order_line(@order, @site)
     render :layout => false
   end

   def update
     load_order
     @order.user_data_entry = current_user
     if current_user.data_entry?
       @order.status = Order::ORDER_STATUS_TO_BE_REVIEWED
     end

     if @order.update_attributes params[:order]
       @order.update_approval if current_user.data_entry_and_reviewer?
       redirect_to admin_orders_path, :notice => 'Order has been updated succesfully'
     else
       errors = []
       errors += @order.errors.full_messages
       @order.order_lines.each do |order_line|
         if order_line.errors.size > 0
            errors += order_line.errors.full_messages
         end
       end
       flash.now[:alert] = "Failed to save order with errors: " + errors.join("\n")
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

   def load_order
     @order ||= Order.includes(:order_lines => :commodity).find params[:id]
   end

   def build_commodity_order_line order, site
     existing_commodities = order.order_lines.map do |order_line| 
       order_line.commodity
     end 

     non_existing_commodities = Commodity.order('name asc')
                                         .includes(:commodity_category)
                                         .all
                                         .select{|commodity| !existing_commodities.include?(commodity) }


     order_line_completer = OrderLineCompleter.new(order)

     non_existing_commodities.each do |commodity| 
       order.order_lines.build :commodity => commodity,
                               :pack_size => commodity.pack_size,
                               :arv_type => commodity.commodity_category.com_type,
                               :stock_on_hand => nil,
                               :monthly_use => nil,
                               :skip_bulk_insert => true,
                               :number_of_client => order_line_completer.query_number_of_patient(commodity),
                               :site_id => order.site.id,
                               :suggestion_order => order.site.suggestion_order,
                               :order_frequency => order.site.order_frequency,
                               :test_kit_waste_acceptable => order.site.test_kit_waste_acceptable
     end
   end
  end
end