require 'spreadsheet'

class SurvSite < ActiveRecord::Base
  attr_accessible :import_surv_id, :month, :site_id, :year
  belongs_to :import_surv
  has_many :surv_site_commodities
  belongs_to :site

  def find_surv site_id, date_str
  	date = Date.parse date_str
  	year = date.year	
  	months = [ '' , 'Jan' , 'Feb' ,'March' , 'April', 'May', 'Jun', 'July', 'August', 'September', 'Octomber', 'November', 'December' ]
  	month = months[date.month]
  	where(['site_id = :site_id AND year = :year AND month = :month', :site_id => site_id, :year => year, :month => month ]).first

  	
  end 

end
