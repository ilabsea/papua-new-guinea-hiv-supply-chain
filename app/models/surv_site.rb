require 'spreadsheet'

class SurvSite < ActiveRecord::Base
  attr_accessible :import_surv_id, :month, :site_id, :year, :surv_type
  belongs_to :import_surv
  has_many :surv_site_commodities
  belongs_to :site

  def self.find_surv_type site_id, date , type
  	year = date.year	
  	months = [ '' , 'January' , 'February' ,'March' , 'April', 'May', 'June', 'July', 'August', 'September', 'Octomber', 'November', 'December' ]
  	month = months[date.month]

  	SurvSite.order('id DESC').where([' surv_type = :surv_type AND site_id = :site_id AND year = :year AND month = :month', 
                                    :site_id => site_id, :year => year, :month => month, :surv_type => type]).first
  end

  def self.find_survs site_id, date
    {  
      CommodityCategory::TYPES_KIT  => find_surv_type(site_id, date , ImportSurv::TYPES_SURV1 ), 
      CommodityCategory::TYPES_DRUG => find_surv_type(site_id, date , ImportSurv::TYPES_SURV2 ) 
    }
  end



end
