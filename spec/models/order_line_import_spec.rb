require 'spec_helper'

describe OrderLineImport do
  describe '.import OrderLine to an order without validation' do
    before(:each) do
      @order = FactoryGirl.create :order
      @excel_file = File.dirname(__FILE__) + "/data/template_test.xls"

      @order_line_import = OrderLineImport.new @order, @excel_file
      @order_line_import.missing_commodities = []

      #commodities
      @names_test = [ 'BD FACS Rinse 5L', 'BD FACSCount Thermal Paper', 'CD4 Controls', 'CD4 Reagents', 'DBS Bundles for Early Iinfant Diagnosis testing']
      @names_req = [ "AZT/3TC/NVP", "AZT/3TC/EFV", "CTX",  "D4T/3TC/EFV"]

      @names = @names_test + @names_req

      @commodity_category = FactoryGirl.create :commodity_category , name: 'Line1' 

      @names.each do |name|
        FactoryGirl.create :commodity, name: name, pack_size: 3.0
      end
    end


    describe '#load_arv_test' do
      it "should load data to orderline in database from excell file tabbed 1" do
        @order_line_import.load_arv_test
        order_lines = OrderLine.all

        order_lines.size.should eq 5

        order_lines.map{|order_line| order_line.commodity.name}.should =~ @names_test

        # monthly_use = [(342/3.0).ceil, (253/3.0).ceil, (876/3.0).ceil, (2341/3.0).ceil, (513/3.0).ceil]
        monthly_use = [342, 253, 876, 2341, 513]
        order_lines.map(&:monthly_use).should =~ monthly_use

        # stock_on_hand = [ (21/3.0).ceil, (11/3.0).ceil, (4/3.0).ceil, (9/3.0).ceil, (10/3.0).ceil ]
        stock_on_hand = [ 21, 11, 4, 9, 10 ]
        order_lines.map(&:stock_on_hand).should =~ stock_on_hand

        @order_line_import.missing_commodities.size.should eq 0
      end
    end

    describe '#load_arv_req' do
      it "should load data to order lines in database from excell tabbed 0" do
        @order_line_import.load_arv_req
        order_lines = OrderLine.all

        order_lines.size.should eq 4
        order_lines.map{|order_line| order_line.commodity.name}.should =~ @names_req

        stock_on_hand = [50, 5, 0, 5]
        order_lines.map(&:stock_on_hand).should =~ stock_on_hand

        monthly_use   = [200, 152, 254, 600]
        order_lines.map(&:monthly_use).should =~ monthly_use

        @order_line_import.missing_commodities.count.should eq 1
        @order_line_import.missing_commodities[0].should eq 'D4T/3TC/NVP'
      end
    end

    describe '#import' do
      it "should import orderline in database from both tabs" do
        @order_line_import.import
        order_lines = OrderLine.all

        order_lines.size.should eq 9
        order_lines.map{|order_line| order_line.commodity.name}.should =~ @names

        @order_line_import.missing_commodities.count.should eq 1
        @order_line_import.missing_commodities[0].should eq 'D4T/3TC/NVP'
      end
    end

  end


end