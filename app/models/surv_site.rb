require 'spreadsheet'

class SurvSite < ActiveRecord::Base

  belongs_to :import_surv
  has_many :surv_site_commodities, :dependent => :destroy
  belongs_to :site

  attr_accessible :site_id, :site, :month, :year, :surv_site_commodities_attributes
  accepts_nested_attributes_for :surv_site_commodities

  TYPES = [ [ 'Surv1', CommodityCategory::TYPES_KIT ] , [ 'Surv2', CommodityCategory::TYPES_DRUG ] ]
  MONTHS = [ 'January' , 'February' ,'March' , 'April', 'May', 'June', 'July', 'August', 'September', 'Octomber', 'November', 'December' ]
  
  validates :month, inclusion: { :in => MONTHS, :message => "%{value} is not a valid month" }, :allow_blank => true
  validates :year, :numericality => { :only_integer => true}, :allow_blank => true

  def self.find_surv_type site_id, date , type
  	year = date.year	
  	month = SurvSite::MONTHS[date.month]
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
