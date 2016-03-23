module Admin
 class OrderStatusController < Controller

   load_and_authorize_resource
   skip_load_resource
   skip_authorize_resource

   def index
     @orders = Order.includes(:site, :user_data_entry, :review_user)
     @orders = @orders.where(["orders.order_number like ? ", "#{params[:order_number]}%" ]) if params[:order_number].present?
     @orders = @orders.of_user(current_user)
                      .embed_total_shipped
                      .order('id desc')
                      .paginate(paginate_options)

   end
  end
end
