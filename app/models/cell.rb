require 'spreadsheet'

class Cell
  attr_accessor :row, :column
  def initialize row, column
    @row = row
    @column = column
  end
end