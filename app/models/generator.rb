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

	def draw_table cell1, cell2, cell_datas = {}, options={}
		row = cell2.row - cell1.row
		col = cell2.column - cell1.column
		border = :thin # options[:border]


		if(row==1)
			col.times.each do |c|
				format_options = cell_datas["0_#{c}_format"] || options

				format = Spreadsheet::Format.new format_options
				format.left   = :none
				format.top    = :none
				format.bottom = :none
				format.right  = :none

				if c==0
					format.left   = border
					format.top    = border
					format.bottom = border
				elsif c== col-1
					format.right  = border
					format.bottom = border
					format.top    = border	
				else
					format.top    =border
					format.bottom = border	
				end	

				data = cell_datas["0_#{c}"] || ""
				cell = Cell.new(cell1.row, cell1.column + c)
				set_cell_format cell, format
				write_data cell, data
			end	
			return 
		elsif col==1
			row.times.each do |r|
				format_options = cell_datas["#{r}_#{0}_format"] || options

				format = Spreadsheet::Format.new format_options
				format.left   = :none
				format.top    = :none
				format.bottom = :none
				format.right  = :none

				if r==0
					format.left   = border
					format.top    = border
					format.right = border
				elsif r== row-1
					format.right  = border
					format.bottom = border
					format.left    = border	
				else
					format.left    =border
					format.right = border	
				end	

				data = cell_datas["#{r}_#{0}"] || ""
				cell = Cell.new(cell1.row + r, cell1.column )
				set_cell_format cell, format
				write_data cell, data
			end		
			return	
		end

		row.times.each do |r|
			col.times.each do |c|
				format_options = cell_datas["#{r}_#{c}_format"] || options
				format = Spreadsheet::Format.new format_options
				cell = Cell.new(cell1.row + r, cell1.column + c)

				format.left   = :none
				format.top    = :none
				format.bottom = :none
				format.right  = :none

				if(r==0 && c==0)
					format.left = border
					format.top  = border
				elsif( r == 0 && c == col-1 )
					format.top   = border
					format.right = border
				
				elsif r==row-1 && c == 0
					format.left   = border
					format.bottom = border
				elsif r==row-1	&& c== col-1
					format.bottom = border
					format.right  = border

				elsif r == 0 
					format.top    = border
				elsif r==row-1
					format.bottom = border

				elsif c==0
					format.left  = border
				elsif c==col-1
					format.right = border	
				end

				data = cell_datas["#{r}_#{c}"] || ""
				set_cell_format cell, format
				write_data cell, data
			end
		end
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

	def draw_table cell1, cell2, cell_datas = {}, options={:border => :thin}
		@current_sheet.draw_table cell1, cell2, cell_datas,  options
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

	def title_format
		{:color => :black, :weight => :bold, :size => 14, :border => :thin, :pattern_fg_color=> :xls_color_18, :pattern => 1 }
	end

	def write_cell_lock cell, data
		format_content = Spreadsheet::Format.new :color => :black, :border => :thin, :pattern_fg_color=> :silver, :pattern => 1 
		current_sheet.write_data cell, data
		current_sheet.set_cell_format cell, format_content
	end

	def write_cell_title cell, data
		format_header  = Spreadsheet::Format.new self.title_format
		current_sheet.write_data cell, data
		current_sheet.set_cell_format cell, format_header
		current_sheet.row_height cell.row , 20
	end

	def merge_cells cell1, cell2
		current_sheet.merge_cells cell1, cell2
	end

	def body_format
		{:color => :black, :border => :thin }
	end

	def write_cell_body cell, data
		format_content = Spreadsheet::Format.new self.body_format
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

	def write_last_cell data, border_rigth = :thin
		format = Spreadsheet::Format.new
		format.left   = :none;
		format.right  = border_rigth
		format.top    = border_rigth
		format.bottom = border_rigth
		write_cell Cell.new(current_row, self.total_column-1), data

	end

	def _drug_sheet_data
		#Write Data to Template
		CommodityCategory.includes(:commodities).drug.each do |commodity_category|
			draw_table Cell.new(current_row, 0), Cell.new(current_row + 1, self.total_column),{"0_0" =>commodity_category.name}, self.title_format
			self.row_height current_row, 20
			move_next
			commodity_category.commodities.each do |commodity|
				items = [ commodity.name, commodity.strength_dosage, commodity.abbreviation, commodity.quantity_per_packg,
						commodity.unit.name, '',  '',  '',  '',  '', ''
				]

				items.each_with_index do |item, index|
					item.blank? ?  write_cell_body(Cell.new(current_row, index) , item) : write_cell_lock(Cell.new(current_row, index) , item) 
				end
				move_next
			end
		end
	end

	def _drug_sheet_header

		merge_cells(Cell.new(current_row ,0), Cell.new(current_row ,4) )
		write_cell_title Cell.new(current_row, 0) , 'ARV and TEST KIT REQUISITION FOR'	

		merge_cells(Cell.new(current_row,5), Cell.new(current_row, self.total_column-1) )
		write_cell_title Cell.new(current_row, 5), 'Papua New Guinea National Department of Health'

		texts = [ '1) Please remember, when submitting orders YOU MUST:', 
				  '2) Submit the "Surv 2: Monthly Data Collection Sheet" (including total number of patients on each regimen) when requesting ARVs;', 
				  '3) Submit the "VCT Monthly Summary Sheet" when requesting Test Kits;',
				  '4) Indicate your Current Stock On Hand of ARVs or Test Kits, monthly consumption and earliet expiry of stock'
		]
		move_next

		texts.each do |text|
			draw_table(Cell.new(current_row, 0), Cell.new(current_row+1, total_column), {'0_0' => text})
			move_next
		end

		move_next
		# leave an empty row
		draw_table Cell.new(current_row, 0), Cell.new(current_row + 1, 5 ), { '0_0' => 'FROM (Clinic/Hospital Name):' }

		draw_table Cell.new(current_row, 6), Cell.new(current_row + 1 , self.total_column ), {'0_0' => 'Date:' }

		move_next
		texts = { '0' => 'Add',  '3' => 'Ph:' , '5' => 'Fax:', '8' => 'Email:' }
		self.total_column.times.each do |i|
			text = texts["#{i}"] || ''
			write_cell_body Cell.new(current_row, i), text
		end

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
		move_next

	end

	def _drug_sheet_footer
		move_next
		write_cell Cell.new(current_row, 0), 'Requesting officer, please sign and date:', :weight => :bold
		merge_cells Cell.new(current_row,0), Cell.new(current_row, 3)

		write_cell Cell.new(current_row, 5), 'Co-note Number(s)'

		move_next
		draw_table Cell.new(current_row , 5) , Cell.new(current_row + 4 , self.total_column)

		draw_table Cell.new(current_row, 0), Cell.new(current_row+4, 4), cell_datas = {
			"0_0" => 'Name and Designation',
			"3_0" => 'Signature',
			"3_2" => 'Date'
		}

		move_next 4
		write_cell Cell.new(current_row, 0), 'Authorising Officer :', :weight => :bold

		move_next

		draw_table Cell.new(current_row, 0), Cell.new(current_row+2, 4), {
			'1_0' => 'Supply Authorised Singnature',
			'1_2' => 'Date'
		}

		draw_table Cell.new(current_row, 5), Cell.new(current_row+2, self.total_column), {
			'0_0' => 'Recieving Officer:' ,
			'0_2' => 'Dispatch Officer:' ,
			'1_0' => 'Date',
			'1_2' => 'Date'
		}

		move_next 3

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
		move_next

		texts = [
			'Please remember, when submitting orders YOU MUST:',
			'1) Submit a completed "SURV1: HIV Monthly Testing Summary" AND "CD4 testing Monthly Summary" for the past month.',
			'2) Indicate on this form your current "Stock On Hand" of all test kits and other supplies;',
			'3) After receiving your order, please indicate quantity received in last column and fax or email to Logistics Unit'
		]

		texts.each do |text|
			draw_table Cell.new(self.current_row, 0), Cell.new(self.current_row+1, self.total_column ), {'0_0' => text}
			move_next
		end

		draw_table Cell.new(current_row, 0), Cell.new(current_row + 1, self.total_column), {'0_5' => 'Folio No.'}
		move_next

		draw_table Cell.new(current_row, 0), Cell.new(current_row + 1, self.total_column), 
		{ '0_0' => 'FROM (Clinic/Hospital Name):', '0_1' =>  'DATE:' }
		move_next

		#headers = [ 'Laboratory Test Kits/Reagents' , 'Issue Units', 'Stock On Hand' , 'Qty Required', 'Quantity Amended' , 'Quantity Issued', 'Check' , 'Quantity Received' ]
		headers = [ 'Laboratory Test Kits/Reagents' , 'Issue Units', 'Stock On Hand' , 'Monthly Used', 'Earliest Expiry' , 'Quantity Allocated', 'Quantity Issued', 'Check' ]
		headers.each_with_index do |header, index|
			write_cell_bold Cell.new(current_row, index), header
		end
		move_next

		['HIV Test Kits and Bundles', '', '', ''].each_with_index do |text, index|
			write_cell_body Cell.new(current_row, index), text
		end

		draw_table Cell.new(current_row, 4), Cell.new(current_row+1, 7), {'0_0' => 'FOR AMS USE ONLY'}
		write_cell_body Cell.new(current_row, self.total_column-1), ''
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
				   text.blank? ?  write_cell_bold(Cell.new(current_row, index), text) : write_cell_lock(Cell.new(current_row, index), text)
				end
				move_next
			end
		end
	end

	def _kit_sheet_footer
		#Footer
		move_next
		merge_cells Cell.new(current_row, 0) , Cell.new(current_row, self.total_column-1)
		write_cell Cell.new(current_row, 0) , 'Requesting officer (please add name, designation, contact number, signature and date):' 
		
		move_next


		draw_table Cell.new(current_row,0), Cell.new(current_row+4, self.total_column-1)
		draw_table Cell.new(current_row,self.total_column-1), Cell.new(current_row+4, self.total_column)

		row_height current_row, 20
		row_height current_row+2, 20
		
		move_next
		write_cell Cell.new(current_row, 0), 'Name and Designation'


		move_next
		write_cell Cell.new(current_row, 0), 'Signature'
		write_cell Cell.new(current_row, 1), 'Date'
		write_cell Cell.new(current_row, 3), 'Contact No'


		move_next 2
		draw_table Cell.new(current_row, 0), Cell.new(current_row, self.total_column-1), {
			'0_0' => 'Authorising Officer (Please sign and add date, dispatching officer to also add co-note number):',
			'0_6' => 'For AMS Use Only'
		}
		write_cell_body Cell.new(current_row, self.total_column-1), ''

		move_next
		row_height current_row, 20
		draw_table Cell.new(current_row, 0), Cell.new(current_row + 1 , 7)
		write_cell_body Cell.new(current_row, self.total_column-1), ''

		move_next
		draw_table Cell.new(current_row, 0), Cell.new(current_row+1, self.total_column-1), {
			'0_0' => 'Supply Authorised',
			'0_1' => 'Date',
			'0_3' => 'Dispatching Officer',
			'0_5' => 'Date'
		}

		write_cell_body Cell.new(current_row, self.total_column-1), '' 

		move_next 3
		write_cell Cell.new(current_row, 0) , 'TNT Connote Number'

		move_next
		texts = [
			'FAX COMPLETED FORM TO 3013753/3257172' ,
			'Any queries, please call 3013731/ 71906173'
		]

		texts.each do |text|
		  row_height current_row, 25
		  merge_cells Cell.new(current_row, 0) , Cell.new(current_row, self.total_column-1)
		  write_cell  Cell.new(current_row, 0) , text, :size => 16, :horizontal_align => :centre
		  move_next
		end

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