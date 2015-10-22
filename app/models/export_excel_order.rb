require 'spreadsheet'

class ExportExcelOrder
  def initialize(year, month)
    @month = month.to_i + 1
    @year = year.to_i
    Spreadsheet.client_encoding = 'UTF-8'
    @book = Spreadsheet::Workbook.new
  end

  def save_to_file(file_name)
    start_date = Date.new(@year, @month, 1)
    end_date   = Date.new(@year, @month, -1)
    p "file name: #{file_name}"

    orders = Order.includes(:site, :order_lines).where([' orders.order_date BETWEEN ? AND ? ', start_date, end_date ])
    p orders
    orders.each do |order|
      write_order(order)
    end
    write_to_file(file_name)
  end

  def write_order(order)
    @book.create_worksheet name: order.site.name
  end

  def write_to_file(file_name)
    p "file name in write: #{file_name}"
    @book.write file_name
  end
end