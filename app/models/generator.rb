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


	attr_accessor :current_sheet, :current_row, :total_column

	def total_column=(total)
		@total_column = total
	end

	def total_column
		@total_column
	end

	def current_row
		@current_row || 0
	end

	def current_sheet
		@current_sheet
	end

	def current_sheet=(sheet)
		p "current sheet "
		p sheet
		@current_sheet = sheet
	end

	def current_row=(row)
		@current_row = row
	end

	def move_next( step = 1)
		@current_row = current_row + step
	end 

	def initialize
		Spreadsheet.client_encoding = 'UTF-8'
		@book = Spreadsheet::Workbook.new
	end

	def write_to_file file_name
		@book.write file_name
	end

	def write_template file_name
		create_drug_sheet
		create_kit_sheet
		write_to_file file_name
	end

	def column_width column, width
		current_sheet.column_width column, width
	end

	def row_height row, height
		current_sheet.row_height row, height
	end

	def write_box_border number_of_rows, number_of_columns
		format  = Spreadsheet::Format.new :color => :black, :border => :thin
		current_sheet.box_format number_of_rows, number_of_columns , format
	end

	def write_cell_title cell, data
		format_header  = Spreadsheet::Format.new :color => :black, :weight => :bold, :size => 14, :border => :thin,
												 :pattern_fg_color=> :xls_color_18, :pattern => 1
		current_sheet.write_data cell, data
		current_sheet.set_cell_format cell, format_header
		current_sheet.row_height cell.row , 20
	end

	def merge_cells cell1, cell2
		current_sheet.merge_cells cell1, cell2
	end

	def write_cell_body cell, data
		format_content = Spreadsheet::Format.new :color => :black, :border => :thin
		current_sheet.write_data cell, data
		current_sheet.set_cell_format cell, format_content
	end

	def write_cell_bold cell, data
		format_content = Spreadsheet::Format.new :color => :black, :weight => :bold, :border => :thin
		current_sheet.write_data cell, data
		current_sheet.set_cell_format cell, format_content
		current_sheet.row_height cell.row , 16
	end

	def write_cell cell, data, options={:color => :black}
		format = Spreadsheet::Format.new options
		current_sheet.write_data cell, data
		current_sheet.set_cell_format cell, format
	end

	def _drug_sheet_data
		#Write Data to Template
		CommodityCategory.includes(:commodities).drug.each do |commodity_category|
			write_cell_title Cell.new(current_row, 0), commodity_category.name
			merge_cells Cell.new(current_row,0), Cell.new(current_row, self.total_column-1)

			move_next

			commodity_category.commodities.each do |commodity|
				write_cell_body Cell.new(current_row, 0) , commodity.name
				write_cell_bold Cell.new(current_row, 1) , commodity.strength_dosage
				write_cell_body Cell.new(current_row, 2) , commodity.abbreviation
				write_cell_bold Cell.new(current_row, 3) , commodity.quantity_per_packg
				write_cell_bold Cell.new(current_row, 4) , commodity.unit.name
				move_next
			end
		end
	end

	def _drug_sheet_header

		# current_row = 0 
		# write_box_border(sheet, 30, 11)

		merge_cells(Cell.new(current_row ,0), Cell.new(current_row ,4) )
		write_cell_title Cell.new(current_row, 0) , 'ARV and TEST KIT REQUISITION FOR'	

		merge_cells(Cell.new(current_row,5), Cell.new(current_row, self.total_column-1) )
		write_cell_title Cell.new(current_row, 5), 'Papua New Guinea National Department of Health'

		head_line_texts = [ '1) Please remember, when submitting orders YOU MUST:' ,
							'2) Submit the "Surv 2: Monthly Data Collection Sheet" (including total number of patients on each regimen) when requesting ARVs;' ,
							'3) Submit the "VCT Monthly Summary Sheet" when requesting Test Kits;',
							'4) Indicate your Current Stock On Hand of ARVs or Test Kits, monthly consumption and earliet expiry of stock',
		]

		move_next	

		head_line_texts.each do |text|
			write_cell_body Cell.new(current_row, 0) , text
			merge_cells  Cell.new(current_row, 0) , Cell.new(current_row, 8)
			move_next
		end	

		move_next
		# leave an empty row
		write_cell_body Cell.new(current_row, 0) , 'FROM (Clinic/Hospital Name):'
		merge_cells( Cell.new(current_row, 0), Cell.new(current_row, 4)  )

		write_cell_body  Cell.new(current_row, 5) , 'Date:'
		merge_cells( Cell.new(current_row, 5) , Cell.new(current_row, self.total_column-1)  )

		move_next

		write_cell_body  Cell.new(current_row, 0) , 'Add:'
		merge_cells Cell.new(current_row, 0) , Cell.new(current_row, 2)

		write_cell_body  Cell.new(current_row, 3) , 'Ph:'
		merge_cells Cell.new(current_row, 3) , Cell.new(current_row, 4)

		write_cell_body Cell.new(current_row, 5) , 'Fax:'
		merge_cells Cell.new(current_row, 5) , Cell.new(current_row, 7)

		write_cell_body Cell.new(current_row, 8), 'Email:'
		merge_cells Cell.new(current_row, 8) , Cell.new(current_row, self.total_column-1)

		move_next

		headers = [ 'Drug',	'Strength/Dosage',	'Abbreviation', 'Qty Per Pack', 'Issue Units', 'Stock On Hand',
			 'Monthly Used',	'Earliest Expiry', 'Quantity Allocated',  'Quantity Issued', 'Check' ]


		headers.each_with_index do |header, column|
			write_cell_body Cell.new(current_row, column), header
		end

		move_next

		write_cell_title Cell.new(current_row, 0) , 'ARVs'
		merge_cells Cell.new(current_row, 0), Cell.new(current_row, 4) 

		write_cell_title Cell.new(current_row, 5) , 'All Entires in Issue Units'
		merge_cells Cell.new(current_row, 5), Cell.new(current_row, 7) 

		write_cell_title  Cell.new(current_row, 8) , 'For Office Use Only'
		merge_cells Cell.new(current_row, 8), Cell.new(current_row, self.total_column-1) 

	end

	def _drug_sheet_footer
		move_next
		write_cell Cell.new(current_row, 0), 'Requesting officer, please sign and date:', :weight => :bold
		merge_cells Cell.new(current_row,0), Cell.new(current_row, 3)

		write_cell Cell.new(current_row, 5), 'Co-note Number(s)'
		merge_cells Cell.new(current_row, 5), Cell.new(current_row, self.total_column-1)	

		move_next

		cell_note_left  = Cell.new(current_row, 5)
		cell_note_right = Cell.new(current_row + 2,  self.total_column-1)
		write_cell cell_note_left, "", :border => :thin
		merge_cells cell_note_left, cell_note_right
		
		write_cell Cell.new(current_row, 0), 'Name and Designation'

		move_next 2

		write_cell Cell.new(current_row, 0), 'Signature'
		merge_cells Cell.new(current_row, 0) , Cell.new(current_row, 1)

		write_cell Cell.new(current_row, 2), 'Date'
		merge_cells Cell.new(current_row, 2) , Cell.new(current_row, 3)

		move_next

		write_cell Cell.new(current_row, 0), 'Authorising Officer :', :weight => :bold

		move_next

		write_cell Cell.new(current_row, 0), ''
		write_cell Cell.new(current_row, 2), ''

		write_cell Cell.new(current_row, 5), 'Recieving Officer:'
		write_cell Cell.new(current_row, 7), 'Dispatch Officer:'

		move_next

		write_cell Cell.new(current_row,0), 'Supply Authorised Singnature'
		merge_cells Cell.new(current_row,0), Cell.new(current_row, 1)

		write_cell Cell.new(current_row,2), 'Date:'
		merge_cells Cell.new(current_row,2), Cell.new(current_row, 3)

		write_cell Cell.new(current_row,5), 'Date:'
		write_cell Cell.new(current_row,7), 'Date:'

		move_next

		write_cell Cell.new(current_row, 0), 'Fax Completed Form To 3257172/3013753', :weight => :bold, :horizontal_align => :centre
		merge_cells Cell.new(current_row, 0), Cell.new(current_row, self.total_column-1)
		
		move_next

		write_cell Cell.new(current_row, 0), 'Any Queries, please call 301-3734/301-3731', :weight => :bold, :horizontal_align => :centre
		merge_cells Cell.new(current_row, 0), Cell.new(current_row, self.total_column-1)
	end

	def create_drug_sheet
		sheet_arv  = @book.create_worksheet :name => Generator::SHEET_ARV_REQ
		self.current_sheet = Sheet.new(sheet_arv)
		self.total_column = 11

		self.total_column.times.each do |column|
			column_width(column, 20)
		end

		column_width(2,60)
		_drug_sheet_header
		_drug_sheet_data
		_drug_sheet_footer	
	end

	def _kit_sheet_header
		merge_cells Cell.new(current_row, 0), Cell.new(current_row , self.total_column-1)
		write_cell_title Cell.new(current_row, 0) , 'HIV TEST KIT REQUISITION FORM'
		row_height 0, 30

		intro_str = <<-EOD
Please remember, when submitting orders YOU MUST:
1) Submit a completed "SURV1: HIV Monthly Testing Summary" AND "CD4 testing Monthly Summary" for the past month.
2) Indicate on this form your current "Stock On Hand" of all test kits and other supplies;
3) After receiving your order, please indicate quantity received in last column and fax or email to Logistics Unit
		EOD

		move_next

		write_cell_body Cell.new(current_row, 0) , intro_str
		row_height current_row, 60
		merge_cells Cell.new(current_row, 0), Cell.new(current_row, self.total_column-1)

		move_next

		write_cell Cell.new(current_row, 0) , ''
		merge_cells Cell.new(current_row, 0) , Cell.new(current_row, 4) 

		write_cell Cell.new(current_row, 5) , 'Folio No.', :border => :thin
		merge_cells Cell.new(current_row, 5) , Cell.new(current_row, self.total_column-1) 

		move_next

		write_cell_body Cell.new(current_row, 0) , 'FROM (Clinic/Hospital Name):'
		
		merge_cells Cell.new(current_row, 1), Cell.new(current_row, self.total_column-1)
		write_cell_body Cell.new(current_row, 1) , 'DATE:'

		move_next

		headers = [ 'Laboratory Test Kits/Reagents' , 'Issue Units', 'Stock On Hand' , 'Qty Required', 'Quantity Amended' , 'Quantity Issued', 'Check' , 'Quantity Received' ]

		headers.each_with_index do |header, index|
			write_cell_bold Cell.new(current_row, index), header
		end

		move_next

		write_cell_bold Cell.new(current_row, 0), 'HIV Test Kits and Bundles'

		merge_cells Cell.new(current_row, 4), Cell.new(current_row, 6)
		write_cell_bold Cell.new(current_row, 4), 'FOR AMS USE ONLY'

		move_next
	end

	def _kit_sheet_data
		CommodityCategory.includes(:commodities).kit.each do |commodity_category|

			merge_cells Cell.new(current_row, 0 ), Cell.new(current_row, self.total_column-1)
			write_cell_title Cell.new(current_row, 0), commodity_category.name
			
			move_next

			commodity_category.commodities.each do |commodity|
				items = [ commodity.name, commodity.unit.name, '', '', '', '' , '', '']

				items.each_with_index do |text, index|
					write_cell_bold Cell.new(current_row, index), text
				end

				move_next
			end
		end
	end

	def _kit_sheet_footer
		#Footer
		merge_cells Cell.new(current_row, 0 ) , Cell.new(current_row, self.total_column-1)
		write_cell_bold Cell.new(current_row, 0), 'Requesting officer (please add name, designation, contact number, signature and date):' 

		move_next
		merge_cells Cell.new(current_row, 0) , Cell.new(current_row, self.total_column-1)
		write_cell_body Cell.new(current_row, 0) , ''
		row_height current_row, 30

		move_next
		write_cell Cell.new(current_row, 0), 'Name and Designation'
		
		move_next
		merge_cells Cell.new(current_row, 0) , Cell.new(current_row, self.total_column-1 )
		row_height current_row, 20
		write_cell_body Cell.new(current_row, 0) , ''

		move_next
		write_cell_body Cell.new(current_row, 0) , 'Signature'

		merge_cells Cell.new(current_row, 1), Cell.new(current_row, 2)
		write_cell_body Cell.new(current_row, 1) , 'Date'

		merge_cells Cell.new(current_row, 3), Cell.new(current_row, self.total_column-1)
		write_cell_body Cell.new(current_row, 3 ), 'Contact No'

		move_next 2
		merge_cells Cell.new(current_row, 0), Cell.new(current_row, 3)
		write_cell_bold Cell.new(current_row, 0), 'Authorising Officer (Please sign and add date, dispatching officer to also add co-note number):'

		merge_cells Cell.new(current_row, 4) , Cell.new(current_row, 6)
		write_cell_bold Cell.new(current_row, 4) , 'For AMS Use Only'

		write_cell_body Cell.new(current_row, self.total_column-1), ''

		move_next
		row_height current_row, 30
		write_cell_body Cell.new(current_row, 0), ''
		write_cell_body Cell.new(current_row, self.total_column-1), ''

		move_next
		write_cell_body Cell.new(current_row, 0) , 'Supply Authorised'
		write_cell_body Cell.new(current_row, 1) , 'Date'

		merge_cells Cell.new(current_row, 2), Cell.new(current_row, 4)
		write_cell Cell.new(current_row, 2) , 'Dispatching Officer', :border => :thin, :horizontal_align => :centre

		merge_cells Cell.new(current_row, 5), Cell.new(current_row, 6)
		write_cell_body Cell.new(current_row, 5) , 'Date'

		write_cell_body Cell.new(current_row, 7), ''

		move_next
		row_height current_row, 30
		write_cell  Cell.new(current_row, 0), 'TNT Connote Number', :align => :bottom

		move_next

		multi_str = <<-EOD
FAX COMPLETED FORM TO 3013753/3257172
Any queries, please call 3013731/ 71906173'
		EOD

		row_height current_row, 60
		merge_cells Cell.new(current_row, 0) , Cell.new(current_row, self.total_column-1)
		write_cell Cell.new(current_row, 0) , multi_str, :size => 16, :horizontal_align => :centre, :border => :thin

	end

	def create_kit_sheet
		sheet_test = @book.create_worksheet :name =>  Generator::SHEET_TEST_REQ
		self.current_sheet = Sheet.new(sheet_test)
		row_height 1, 20
		self.total_column = 8

		self.current_row = 0

		self.total_column.times.each do |index|
			column_width index, 20
		end

		column_width 0, 40
		_kit_sheet_header
		_kit_sheet_data
		_kit_sheet_footer	
	end

	def self.xls file_name
		generator = Generator.new
		generator.write_template file_name
	end
end