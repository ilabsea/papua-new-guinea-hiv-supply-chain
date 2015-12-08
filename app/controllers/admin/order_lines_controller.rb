module Admin
  class OrderLinesController < Controller
    def index
      params[:type] ||= CommodityCategory::TYPES_DRUG
      @order = Order.find params[:order_id]
      if params[:type] == CommodityCategory::TYPES_DRUG
        @order_lines = @order.order_lines.drug.paginate(paginate_options)
      else params[:type] == CommodityCategory::TYPES_KIT
        @order_lines = @order.order_lines.kit.paginate(paginate_options)  
      end
    end

    def approve_all
      order = Order.find(params[:order_id])

      order_lines = order.order_lines
      if(params[:type] == CommodityCategory::TYPES_DRUG )
        order_lines = order_lines.drug
      elsif params[:type] == CommodityCategory::TYPES_KIT
        order_lines = order_lines.kit
      end

      if order_lines.update_all(:status  => OrderLine::STATUS_APPROVED)
        order.review_user = current_user
        order.update_status_accepted
        order.review_date = Time.zone.now
        order.save
        redirect_to review_admin_order_path(order, type: params[:type]), notice: 'Orders have been approved'
      else
        redirect_to review_admin_order_path(order, type: params[:type]), notice: 'Failed to approve orders'
      end

    end

    def approve
      @order = Order.find(params[:order_id])
      @order_line = OrderLine.find(params[:id])
      @order_line.status = OrderLine::STATUS_APPROVED
      @order_line.user_reviewer_note = params[:order_line][:user_reviewer_note]
      @order_line.quantity_suggested = params[:order_line][:quantity_suggested]

      if @order_line.save(:validate => false)
        @order.review_user = current_user
        @order.update_status_accepted
        @order.review_date = Time.zone.now
        @order.save
        render :json => {:status => @order_line.status, :code => :success, :arv_type => @order_line.arv_type, :type => :approved  }       
      else
        render :json => {:code => :failed, :error => @order_line.errors.full_messages[0], :arv_type => @order_line.arv_type, :type => :approved }
      end
    end

    def reject
      @order = Order.find(params[:order_id])
      @order_line = @order.order_lines.find(params[:id])
      @order_line.status = OrderLine::STATUS_REJECTED 

      @order_line.user_reviewer_note = params[:order_line][:user_reviewer_note]
      @order_line.quantity_suggested = params[:order_line][:quantity_suggested]

      if @order_line.save(:validate => false)
        @order.status = Order::ORDER_STATUS_TO_BE_REVISED
        @order.review_user = current_user
        @order.review_date = Time.zone.now
        @order.save
        render :json => {:status => @order_line.status, :code => :success, :arv_type => @order_line.arv_type,:type => :rejected  }       
      else
        render :json => {:code => :failed, :error => @order_line.errors.full_messages[0], :arv_type => @order_line.arv_type, :type => :rejected }
      end
    end

  end

end