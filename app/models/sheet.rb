require 'spreadsheet'

class Sheet
    attr_accessor :sheet
 
    def initialize sheet
         @sheet  = sheet
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
        elsif r==row-1  && c== col-1
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