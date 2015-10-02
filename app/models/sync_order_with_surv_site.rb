class SyncOrderWithSurvSite
  def initialize(surv_site)
    @surv_site = surv_site
  end

  def start
    begining_of_month = Date.new(@surv_site.year, @surv_site.month + 1, 1)
    end_of_month  = begining_of_month + 1.month
    order = Order.where(['site_id = ? AND order_date >= ? AND order_date < ? ', @surv_site.site_id, begining_of_month, end_of_month])
                 .includes(:order_lines).first

    if order
      order.order_lines.each do |order_line|
        update_quantity_order_line(order_line) if match?(order_line)
      end

    end
  end

  def update_quantity_order_line order_line
    @surv_site.surv_site_commodities.each do |surv_site_commodity|
      if (order_line.commodity_id == surv_site_commodity.commodity_id)
        order_line.number_of_client = surv_site_commodity.quantity
        order_line.save
      end
    end
  end

  def match?(order_line)
    (@surv_site.surv_type == ImportSurv::TYPES_SURV2 && order_line.arv_type == CommodityCategory::TYPES_DRUG ) ||
    (@surv_site.surv_type == ImportSurv::TYPES_SURV1 && order_line.arv_type == CommodityCategory::TYPES_KIT )

  end

end