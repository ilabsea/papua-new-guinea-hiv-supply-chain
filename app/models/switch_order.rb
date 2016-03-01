class SwitchOrder
  attr_accessor :order
  attr_accessor :error

  def initialize(order)
    @order = order
  end

  def reject
    if self.order.rejectable?
      self.order.status = Order::ORDER_STATUS_REJECTED
      self.order.rejected_at = Time.zone.now
      save_order
    else
      self.error = "order is not rejectable"
      false
    end
  end

  def unreject
    if self.order.unrejectable?
      self.order.status = Order::ORDER_STATUS_APPROVED
      self.order.unrejected_at = Time.zone.now
      save_order
    else
      self.error = "order is not unrejectable"
      false
    end
  end

  def save_order
    result = self.order.save
    self.error = self.order.errors.full_messages[0] unless result
    result
  end
end
