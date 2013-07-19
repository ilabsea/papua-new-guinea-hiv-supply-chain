class SurvSiteCommodity < ActiveRecord::Base
  attr_accessible :commodity, :commodity_id, :quantity
  belongs_to :surv_site , :counter_cache => true
  belongs_to :site
  belongs_to :commodity
  validates :quantity, :numericality => true, :allow_blank => true
end
