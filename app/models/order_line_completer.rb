class OrderLineCompleter

  def initialize my_order
    @order = my_order
    @surv_sites = SurvSite.includes(:surv_site_commodities).for_site_order(@order)
    @order_line_suggestion = OrderLineSuggestion.new
  end

  def set_quantity_suggested order_line
    quantity_suggested = @order_line_suggestion.suggested_value(order_line)
    
    order_line.system_suggestion = quantity_suggested.to_f.ceil
    order_line.quantity_suggested = order_line.system_suggestion

  end

  def query_number_of_patient commodity
    @surv_sites.each do |surv_site|
      next if surv_site.surv_type != commodity.to_surv_type

      surv_site.surv_site_commodities.each do |surv_site_commodity|
        if surv_site_commodity.commodity_id == commodity.id
          return surv_site_commodity.quantity
        end
      end
    end
    nil
  end

end