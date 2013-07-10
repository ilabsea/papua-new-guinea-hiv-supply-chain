require 'spreadsheet'

class SurvSite < ActiveRecord::Base
  attr_accessible :import_surv_id, :month, :site_id, :year, :surv_type
  belongs_to :import_surv
  has_many :surv_site_commodities
  belongs_to :site

  def self.find_surv site_id, date
  	year = date.year	
  	months = [ '' , 'January' , 'February' ,'March' , 'April', 'May', 'June', 'July', 'August', 'September', 'Octomber', 'November', 'December' ]
  	month = months[date.month]
  	SurvSite.order('id').here(['site_id = :site_id AND year = :year AND month = :month', :site_id => site_id, :year => year, :month => month ])	
  end 

end
