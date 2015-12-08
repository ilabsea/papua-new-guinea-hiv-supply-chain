class OrderLineSuggestion

  def quantity_suggested_list
    to_time   = (Time.zone.now - 1.month).end_of_month
    from_time = (to_time - 2.month).beginning_of_month

    @quantity_suggested_list ||= OrderLine.select('AVG(quantity_suggested) as average, site_id, commodity_id')
                                          .where(['created_at BETWEEN ? AND ?', from_time, to_time])
                                          .group('commodity_id, site_id')
  end

  def average(order_line)
    quantity_suggested_list.each do |suggested_item|
      if suggested_item[:site_id] == order_line.site_id && suggested_item[:commodity_id] == order_line.commodity_id
        return suggested_item[:average]
      end
    end
    nil
  end

  def suggested_value(order_line)
    everage_per_time =  average(order_line)
    everage_per_time = everage_per_time ? everage_per_time : order_line.monthly_use.to_i
    suggested_value = (everage_per_time * order_line.order_frequency) - order_line.stock_on_hand.to_i
    suggested_value
  end

end