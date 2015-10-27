# encoding: utf-8
require 'spreadsheet'
class OrderLineImport 

  def initialize order, file_name
    @book = Spreadsheet.open(file_name)
    @order = order
    @order_line_completer = OrderLineCompleter.new(@order)
  end

  def import
    load_arv_req
    load_arv_test
  end

  def find_commodity_by_name name
    @commodities ||= Commodity.all
    @commodities.each do |commodity|
      return commodity if commodity.name == name
    end
    nil
  end

  def missing_commodities
    @missing_commodities ||= []
  end

  def missing_commodities=(commodities)
    @missing_commodities = commodities
  end

  def add_missing_commodities(name)
    missing_commodities
    @missing_commodities << name
  end

  def load_arv_test
    sheet_arv_test = @book.worksheet 1
    arv_header = 10
    arv_footer = 13
    row_data_count = sheet_arv_test.count - arv_header - arv_footer
    order_lines = []

    row_data_count.times.each do |i|
      index = arv_header + i
      row = sheet_arv_test.row index


      if is_commodities? row
        commodity = find_commodity_by_name(row[0])
        
        if commodity
          pack_size = commodity.pack_size == nil ? 1.0 : commodity.pack_size

          stock_on_hand = row[2].to_i
          monthly_use   = row[3].to_i

          number_of_client = @order_line_completer.query_number_of_patient(commodity)

          params = { :commodity => commodity,
                     :pack_size => pack_size,
                     :arv_type => CommodityCategory::TYPES_KIT,
                     :stock_on_hand => stock_on_hand,
                     :monthly_use => monthly_use,
                     :skip_bulk_insert => true,
                     :number_of_client => number_of_client,
                     :site_id => @order.site.id,
                     :suggestion_order => @order.site.suggestion_order,
                     :order_frequency => @order.site.order_frequency,
                     :test_kit_waste_acceptable => @order.site.test_kit_waste_acceptable
          }

          order_line = @order.order_lines.build(params)
          @order_line_completer.set_quantity_suggested(order_line)
          order_lines << order_line
        else
          info = "Could not find commodity with name:  #{row[0]} at index #{i}"
          add_missing_commodities row[0]
          Rails.logger.info(info)
        end
      end
    end
    bulk_import order_lines
  end

  def load_arv_req
    sheet_arv_request = @book.worksheet 0
    arv_header = 10
    arv_footer = 12

    row_data_count = sheet_arv_request.count - arv_header - arv_footer
    order_lines = [] # bulk import
    row_data_count.times.each do |i|
      index = arv_header + i
      row = sheet_arv_request.row index

      if is_commodities? row
        commodity = find_commodity_by_name(row[0])

        if commodity
          number_of_client = @order_line_completer.query_number_of_patient(commodity)

          params = { :commodity => commodity,
                     :arv_type  => CommodityCategory::TYPES_DRUG,
                     :stock_on_hand => row[5].to_i,
                     :monthly_use   => row[6].to_i,
                     :skip_bulk_insert => true,
                     :number_of_client => number_of_client,
                     :site_id => @order.site.id,
                     :suggestion_order => @order.site.suggestion_order,
                     :order_frequency => @order.site.order_frequency,
                     :test_kit_waste_acceptable => @order.site.test_kit_waste_acceptable
          }

          order_line = @order.order_lines.build(params)
          @order_line_completer.set_quantity_suggested(order_line)
          order_lines << order_line
        else
          info = 'Could not find commodity with name: ' + row[0]
          add_missing_commodities row[0]
          Rails.logger.info(info)
        end
      end
    end
    bulk_import order_lines
  end

  def bulk_import order_lines
    order_lines.each do |order_line|
      order_line.save(validate: false)
    end
  end

  def is_category? row
     !row[0].blank? && row[1].blank?
  end

  def is_commodities? row
    !row[0].blank? && !row[1].blank? 
  end

end