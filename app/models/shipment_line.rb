# == Schema Information
#
# Table name: shipment_lines
#
#  id                 :integer          not null, primary key
#  shipment_id        :integer
#  quantity_suggested :integer
#  quantity_issued    :integer
#  quantity_received  :integer
#  order_line_id      :integer
#  remark             :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class ShipmentLine < ActiveRecord::Base
  belongs_to :shipment, :counter_cache => true
  belongs_to :order_line

  validates :quantity_issued, :presence => true, :allow_blank => true
  attr_accessible :quantity_issued, :quantity_suggested, :order_line_id, :remark
end
