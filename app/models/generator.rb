require 'spreadsheet'

class Cell
	attr_accessor :row, :column
	def initialize row, column
		@row = row
		@column = column
	end
end

class Sheet
    attr_accessor :sheet
 
    def initialize sheet
   	    @sheet 	= sheet
    end

    def merge_cells(cell_start, cell_end)
   		@sheet.merge_cells cell_start.row, cell_start.column, cell_end.row, cell_end.column
    end

    def write_data(cell, data)
		@sheet[cell.row, cell.column] = data
    end

    def set_cell_format(cell, format)
		@sheet.row(cell.row).set_format(cell.column, format)
	end

	def row_height(row, height)
		@sheet.row(row).height = height
	end

	def column_width(column, width)
		@sheet.column(column).width = width
	end

	def box_format(number_of_rows, number_of_columns, format)
		number_of_rows.times.each do |row|
			number_of_columns.times.each do |column|
				set_cell_format Cell.new(row, column), format
			end
		end
	end

end

class Generator 

	SHEET_ARV_REQ = "ARVs requsition forms"
	SHEET_TEST_REQ = "TestRequisitionForm"

	def initialize
		Spreadsheet.client_encoding = 'UTF-8'
		@book = Spreadsheet::Workbook.new
	end

	def write_to_file file_name
		@book.write file_name
	end

	def write_template file_name
		create_sheet_arv
		create_sheet_test
		write_to_file file_name
	end


	def write_box_border sheet, number_of_rows, number_of_columns
		format  = Spreadsheet::Format.new :color => :black, :border => :thin
		sheet.box_format number_of_rows, number_of_columns , format
	end

	def write_cell_title sheet, cell, data
		format_header  = Spreadsheet::Format.new :color => :black, :weight => :bold, :size => 14, :border => :thin,
												 :pattern_fg_color=> :xls_color_18, :pattern => 1
		sheet.write_data cell, data
		sheet.set_cell_format cell, format_header
		sheet.row_height cell.row , 20

	end

	def write_cell_body sheet, cell, data
		format_content = Spreadsheet::Format.new :color => :black, :border => :thin
		sheet.write_data cell, data
		sheet.set_cell_format cell, format_content
	end

	def create_sheet_arv
		sheet_arv  = @book.create_worksheet :name => Generator::SHEET_ARV_REQ
		sheet = Sheet.new(sheet_arv)

		total_column = 11

		total_column.times.each do |column|
			sheet.column_width(column, 20)
		end


		
		sheet.column_width(20,60)


		current_row = 0 
		write_box_border(sheet, 30, 11)

		sheet.merge_cells(Cell.new(current_row ,0), Cell.new(current_row ,4) )
		write_cell_title sheet, Cell.new(current_row, 0) , 'ARV and TEST KIT REQUISITION FOR'
		

		sheet.merge_cells(Cell.new(current_row,5), Cell.new(current_row, 10) )
		write_cell_title sheet, Cell.new(current_row, 5), 'Papua New Guinea National Department of Health'

		head_line_texts = [ '1) Please remember, when submitting orders YOU MUST:' ,
							'2) Submit the "Surv 2: Monthly Data Collection Sheet" (including total number of patients on each regimen) when requesting ARVs;' ,
							'3) Submit the "VCT Monthly Summary Sheet" when requesting Test Kits;',
							'4) Indicate your Current Stock On Hand of ARVs or Test Kits, monthly consumption and earliet expiry of stock',
		]

		current_row = 1	

		head_line_texts.each do |text|
			write_cell_body sheet , Cell.new(current_row, 0) , text
			sheet.merge_cells  Cell.new(current_row, 0) , Cell.new(current_row, 8)
			current_row = current_row + 1
		end	

		current_row = current_row +1
		# leave an empty row
		write_cell_body sheet , Cell.new(current_row, 0) , 'FROM (Clinic/Hospital Name):'
		sheet.merge_cells( Cell.new(current_row, 0), Cell.new(current_row, 4)  )

		write_cell_body sheet , Cell.new(current_row, 5) , 'Date:'
		sheet.merge_cells( Cell.new(current_row, 5) , Cell.new(current_row, 10)  )

		current_row = current_row +1

		write_cell_body sheet , Cell.new(current_row, 0) , 'Add:'
		sheet.merge_cells Cell.new(current_row, 0) , Cell.new(current_row, 2)

		write_cell_body sheet , Cell.new(current_row, 3) , 'Ph:'
		sheet.merge_cells Cell.new(current_row, 3) , Cell.new(current_row, 4)

		write_cell_body sheet , Cell.new(current_row, 5) , 'Fax:'
		sheet.merge_cells Cell.new(current_row, 5) , Cell.new(current_row, 7)

		write_cell_body sheet , Cell.new(current_row, 8), 'Email:'
		sheet.merge_cells Cell.new(current_row, 8) , Cell.new(current_row, 10)

		current_row = current_row +1

		headers = [ 'Drug',	'Strength/Dosage',	'Abbreviation', 'Qty Per Pack', 'Issue Units', 'Stock On Hand',
			 'Monthly Used',	'Earliest Expiry', 'Quantity Allocated',  'Quantity Issued', 'Check' ]


		headers.each_with_index do |header, column|
			write_cell_body sheet , Cell.new(current_row, column), header
		end

		current_row = current_row + 1

		write_cell_title sheet , Cell.new(current_row, 0) , 'ARVs'
		sheet.merge_cells( Cell.new(current_row, 0), Cell.new(current_row, 4) )

		write_cell_title sheet , Cell.new(current_row, 5) , 'All Entires in Issue Units'
		sheet.merge_cells( Cell.new(current_row, 5), Cell.new(current_row, 7) )

		write_cell_title sheet , Cell.new(current_row, 8) , 'For Office Use Only'
		sheet.merge_cells( Cell.new(current_row, 8), Cell.new(current_row, 10) )

	end

	def create_sheet_test
		sheet_test = @book.create_worksheet :name =>  Generator::SHEET_TEST_REQ
		sheet = Sheet.new(sheet_test)
		sheet.row_height 1, 20
		sheet.column_width 0, 60
		write_box_border(sheet, 30, 11)

		write_cell_title sheet, Cell.new(1, 0) , 'HIV TEST KIT REQUISITION FORM'

		intro_str = <<-EOD
			Please remember, when submitting orders YOU MUST:
			1) Submit a completed "SURV1: HIV Monthly Testing Summary" AND "CD4 testing Monthly Summary" for the past month.
			2) Indicate on this form your current "Stock On Hand" of all test kits and other supplies;
			3) After receiving your order, please indicate quantity received in last column and fax or email to Logistics Unit
		EOD
		write_cell_body sheet , Cell.new(3, 0) , intro_str
		write_cell_body sheet , Cell.new(4, 5) , 'Folio No.'
	end


	def self.xls file_name
		generator = Generator.new
		generator.write_template file_name

	end
end