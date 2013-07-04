require 'spreadsheet'

class SurvSite < ActiveRecord::Base
  attr_accessible :import_surv_id, :month, :site_id, :year

  belongs_to  :import_surv
  has_many :surv_site_commodities

  def self.import book
  	sheet_arv_request = book.worksheet 0
  	row = sheet_arv_request.row 0
  end
end
