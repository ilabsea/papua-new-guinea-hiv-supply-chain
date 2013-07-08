require 'spreadsheet'

class SurvSite < ActiveRecord::Base
  attr_accessible :import_surv_id, :month, :site_id, :year

  def self.import book
  	sheet_arv_request = book.worksheet 0
  	row = sheet_arv_request.row 0
  	debugger
	end
end
