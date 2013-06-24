require 'spreadsheet'
class RequisitionImport 
	def initialize(file_name)
		@book = Spreadsheet.open(file_name)
	end

	def self.import file_name
		@book = Spreadsheet.open(file_name)
		load_arv_req
	end

	def self.load_arv_req
		sheet_arv_request = @book.worksheet 0
		arv_header = 10
		arv_footer = 12

		row_data_count = sheet_arv_request.count - arv_header - arv_footer
		
		row_data_count.times.each do |i|
			index = arv_header + 1
			row = sheet_arv_request[index]
			if is_commodities? row
				commodity = Commodity.find_by_name row[0].strip
				stock_on_hand =  row[4].strip
				monthly_used  = row[5].strip
			end

		end
	end

	def self.is_category? row
	   !row[0].blank? && row[1].blank? && row[2].blank?
	end

	def self.is_commodities? row
		!row[0].blank? && !row[1].blank? && row[2].blank?
	end

end