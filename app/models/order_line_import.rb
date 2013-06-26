require 'spreadsheet'
class OrderLineImport 

	def self.import order
		@order = order
		file_name = @order.requisition_report.form.current_path
		@book = Spreadsheet.open(file_name)
		load_arv_req
	end

	def self.load_arv_req
		sheet_arv_request = @book.worksheet 0
		arv_header = 10
		arv_footer = 12

		row_data_count = sheet_arv_request.count - arv_header - arv_footer
		
		row_data_count.times.each do |i|
			index = arv_header + i
			row = sheet_arv_request.row index
			if is_commodities? row
				commodity = Commodity.find_by_name(row[0])
				if commodity
					params = { :commodity => commodity,
							   :stock_on_hand =>  row[4].to_i,
							   :monthly_use   =>  row[5].to_i }
					order_line = @order.order_lines.build params
					order_line.save	
				else
				    info =  'Could not find commodity with name: ' + row[0]
				    p info
				    Rails.logger.info(info)
				end													  
			end
		end
	end

	def sanitize_column data

	end

	def self.is_category? row
	   !row[0].blank? && row[1].blank? && row[2].blank?
	end

	def self.is_commodities? row
		!row[0].blank? && !row[1].blank? && !row[2].blank?
	end

end