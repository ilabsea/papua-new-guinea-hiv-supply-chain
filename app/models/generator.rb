require 'spreadsheet'

class Generator 


	def self.set_encoding encoding
		Spreadsheet.client_encoding = encoding
	end

	def self.xls file_name
		Spreadsheet.client_encoding = 'UTF-8'
		book = Spreadsheet::Workbook.new

		sheet_arv  = book.create_worksheet :name => 'ARVs requsition forms'
		sheet_test = book.create_worksheet :name => 'TestRequisitionForm'


		current_row = 0 

		sheet_arv[current_row, 0] = 'ARV and TEST KIT REQUISITION FOR'
		sheet_arv[current_row, 4] = 'Papua New Guinea National Department of Health'

		head_line_texts = [ '1) Please remember, when submitting orders YOU MUST:' ,
							'2) Submit the "Surv 2: Monthly Data Collection Sheet" (including total number of patients on each regimen) when requesting ARVs;' ,
							'3) Submit the "VCT Monthly Summary Sheet" when requesting Test Kits;',
							'4) Indicate your Current Stock On Hand of ARVs or Test Kits, monthly consumption and earliet expiry of stock',
			]

		current_row = 1	
		head_line_texts.each do |text|
			sheet_arv[current_row, 0] = text
			current_row = current_row + 1
		end	
		current_row = current_row +1
		# leave an empty row
		sheet_arv[current_row, 0] = 'FROM (Clinic/Hospital Name):'
		sheet_arv[current_row, 5] = 'Date:'

		current_row = current_row +1

		sheet_arv[current_row, 0 ] = 'Add:'
		sheet_arv[current_row, 3 ] = 'Ph:'
		sheet_arv[current_row, 5 ] = 'Fax:'
		sheet_arv[current_row, 8  ] = 'Email:'

		current_row = current_row +1


		headers = [ 'Drug',	'Strength/Dosage',	'Abbreviation', 'Qty Per Pack', 'Issue Units', 'Stock On Hand',
			 'Monthly Used',	'Earliest Expiry', 'Quantity Allocated',  'Quantity Issued', 'Check' ]


		headers.each_with_index do |header, column|
			sheet_arv[current_row, column] = header
		end

		current_row = current_row + 1

		sheet_arv[current_row, 0] = 'ARVs'
		sheet_arv[current_row, 5] = 'All Entires in Issue Units'
		sheet_arv[current_row, 8] = 'For Office Use Only'

		intro_str = <<-EOD
			Please remember, when submitting orders YOU MUST:
			1) Submit a completed "SURV1: HIV Monthly Testing Summary" AND "CD4 testing Monthly Summary" for the past month.
			2) Indicate on this form your current "Stock On Hand" of all test kits and other supplies;
			3) After receiving your order, please indicate quantity received in last column and fax or email to Logistics Unit
		EOD
		sheet_test[3, 0] = intro_str
		sheet_test[4, 5] = 'Folio No.'






		# Sheet test

		sheet_test[1,0] = 'HIV TEST KIT REQUISITION FORM'

		book.write file_name

	end
end