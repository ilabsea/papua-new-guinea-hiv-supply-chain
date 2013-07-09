class SurvSiteCommodity < ActiveRecord::Base
  attr_accessible :commodity_id, :quantity, :surv_site_id
  belongs_to :surv_site, :counter_cache => true
  belongs_to :site
  belongs_to :commodity
end
