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
     elsif current_user.ams?
       @orders = @orders.where(['status = ?', Order::ORDER_STATUS_APPROVED ])
     elsif !params[:type].blank?
       @orders = @orders.of_status(params[:type])
     end

     @orders = @orders.of_user(current_user)
                      .in_between(@date_start, @date_end)
                      .embed_total_shipped
                      .order('id desc')

     @orders = @orders.paginate(paginate_options)

   end

   def show
     load_order
   end

   def review
     @type = params[:type] || CommodityCategory::TYPES_DRUG
     load_order
   end

   def reject
    #  order = Order.find(params[:id])
     swicth_order = SwitchOrder.new(@order)

     if(swicth_order.reject)
       redirect_to admin_orders_path, notice: "Order has been rejected"
     else
       redirect_to admin_orders_path, notice: "Failed to reject order #{@order.try(:id)}-#{@order.try(:order_number)} with reason #{swicth_order.error}"
     end
   end

   def unreject
    #  order = Order.find(params[:id])
     swicth_order = SwitchOrder.new(@order)

     if(swicth_order.unreject)
       redirect_to admin_orders_path, notice: "Order has been approved from rejected"
     else
       redirect_to admin_orders_path, notice: "Failed to approved the rejected order #{@order.try(:id)}-#{@order.try(:order_number)} with reason #{swicth_order.error}"
     end
   end

   def create
     @order = Order.new params[:order]
     @order.user_data_entry = current_user
     @order.status = Order::ORDER_STATUS_TO_BE_REVIEWED
     @order.is_requisition_form = false

    if @order.save
      @order.update_approval if current_user.data_entry_and_reviewer?
      redirect_to admin_orders_path, :notice => 'Order has been created'
    else
      errors = {}
      @order.order_lines.each do |order_line|
         if order_line.errors.size > 0
            errors[order_line.errors.full_messages] = order_line.errors.full_messages
         end
      end

      flash.now[:alert] = "Failed to save order with errors: " + errors.values.join("\n")
      render :new
    end
   end

   def tab_order_line
     @site  = Site.find(params[:site_id])
     @order = Order.new(site: @site, order_date: params[:order_date])
     build_commodity_order_line(@order, @site)
     render :layout => false
   end

   def edit
     load_order
     build_commodity_order_line @order, @order.site
   end

   def update
     load_order

     if current_user.data_entry?
       @order.user_data_entry = current_user
       @order.status = Order::ORDER_STATUS_TO_BE_REVIEWED
     elsif current_user.data_entry_and_reviewer?
       @order.approved_user = current_user
     end

     if @order.update_attributes params[:order]
       @order.update_approval if current_user.data_entry_and_reviewer?
       redirect_to admin_orders_path, :notice => 'Order has been updated succesfully'
     else
       errors = {}
       @order.order_lines.each do |order_line|
         if order_line.errors.size > 0
            errors[order_line.errors.full_messages] = order_line.errors.full_messages
         end
       end

       flash.now[:alert] = "Failed to save order with errors: " + errors.values.join("\n")
       render :edit
     end
   end

   def destroy
     Order.transaction do
       @order = Order.find params[:id]
       @order.requisition_report.destroy if @order.requisition_report
     end
     redirect_to admin_orders_path, :notice => 'Order has been deleted succesfully'
   end

   def export_excel
     month = params[:month].to_i + 1
     year = params[:year].to_i

     start_date = Date.new(year, month, 1)
     end_date   = Date.new(year, month, -1)

     orders = Order.includes(:site, order_lines: [ commodity: [:unit] ])
                  .where(['orders.order_date BETWEEN ? AND ? ', start_date, end_date ])
     orders = orders.where(['orders.status = ?', params[:status] ]) if params[:status].present?
     orders = orders.order('sites.name ASC')

     exporter = ExportExcelOrder.new(orders)

     file = "#{Rails.root}/public/data/orders-#{year}-#{month}.xls"
     exporter.save_to_file(file)

     send_file(file,
               type: 'application/xls',
               disposition: 'attachment',
               streaming: true,
               buffer_size: '4096')
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
     @order = Order.includes(order_lines: [commodity: :unit])
                   .order('commodities.position, commodities.name')
                   .find(params[:id])
     @order
   end

   def build_commodity_order_line order, site
     existing_commodities = order.order_lines.map do |order_line|
       order_line.commodity
     end

     non_existing_commodities = Commodity.order('commodities.position ,commodities.name')
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
