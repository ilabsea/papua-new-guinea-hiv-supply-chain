# == Schema Information
#
# Table name: surv_site_commodities
#
#  id           :integer          not null, primary key
#  surv_site_id :integer
#  commodity_id :integer
#  quantity     :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class SurvSiteCommodity < ActiveRecord::Base
  attr_accessible :commodity, :commodity_id, :quantity
  belongs_to :surv_site , :counter_cache => true
  belongs_to :commodity
  validates :quantity, :numericality => { greater_than_or_equal_to: 0}, :allow_blank => true
end
