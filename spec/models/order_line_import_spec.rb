require 'spec_helper'

describe OrderLineImport do
  describe '.import OrderLine to an order without validation' do
  	before(:each) do
  	  @order = FactoryGirl.create :order
      @excel_file = File.dirname(__FILE__) + "/data/template_test.xls"

      #commodities
      @names_test = [ 'BD FACS Rinse 5L', 'BD FACSCount Thermal Paper', 'CD4 Controls', 'CD4 Reagents', 'DBS Bundles for Early Iinfant Diagnosis testing']
      @names_req = [ "AZT/3TC/NVP", "AZT/3TC/EFV", "CTX",  "D4T/3TC/EFV"]  
      @names = @names_test + @names_req

      @commodity_category = FactoryGirl.create :commodity_category , name: 'Line1' 

      @names.each do |name|
        FactoryGirl.create :commodity, name: name
      end
  	end

  	describe 'load_arv ' do
      before(:each) do
        @order_line_import = OrderLineImport.new @order, @excel_file
        @order_line_import.missing_commodities = []
      end

      it "should load data to orderline in database from excell file tabbed 1" do
        @order_line_import.load_arv_test
        OrderLine.all.size.should eq 5
        OrderLine.all.map{|order_line| order_line.commodity.name}.should =~ @names_test
        @order_line_import.missing_commodities.size.should eq 0
      end

      it "should load data to order lines in database from excell tabbed 0" do
        @order_line_import.load_arv_req
        OrderLine.all.size.should eq 4
        OrderLine.all.map{|order_line| order_line.commodity.name}.should =~ @names_req
        @order_line_import.missing_commodities.count.should eq 1
        @order_line_import.missing_commodities[0].should eq 'D4T/3TC/NVP'
      end

      it "should import orderline in database from both tabs" do
        @order_line_import.import
        OrderLine.all.size.should eq 9
        OrderLine.all.map{|order_line| order_line.commodity.name}.should =~ @names
        @order_line_import.missing_commodities.count.should eq 1
        @order_line_import.missing_commodities[0].should eq 'D4T/3TC/NVP'

      end
    
    end

  end


end