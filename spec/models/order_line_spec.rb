require 'spec_helper'

describe OrderLine do

  describe 'validate quantity_suggested with type drug ' do
  	before(:each) do
  		@order = FactoryGirl.create :order
      @order_line_drug = @order.order_lines.build arv_type: CommodityCategory::TYPES_DRUG,
                            site_suggestion: 50 , 
                            test_kit_waste_acceptable: 5, 
                            number_of_client: 20, 
                            consumption_per_client_per_month: 30,
                            stock_on_hand:  100,
                            quantity_suggested: 200
  	end

  	it "should return 60 for order_line cal_drug" do
      @order_line_drug.cal_drug.should eq 60
  	end

    it "should not add errors when quantity_suggested is blank" do
       @order_line_drug.quantity_suggested = ""
       @order_line_drug.quantity_suggested_drug?
       @order_line_drug.errors.full_messages.size.should eq 0
    end
    it "should not add errors when stock_on_hand is blank" do
       @order_line_drug.stock_on_hand = ""
       @order_line_drug.quantity_suggested_drug?.should eq true
       @order_line_drug.errors.full_messages.size.should eq 0
    end


    it "should have add errors to model when drug_calculation is bigger than site suggestion" do
      @order_line_drug.quantity_suggested_drug?.should eq false
      @order_line_drug.errors.full_messages[0].should eq "Stock on hand Invalid!, System calculation = 60% must be less than or equal to site suggestion = 50%"
      @order_line_drug.errors.full_messages[1].should eq "Quantity suggested Invalid!, System calculation = 60% must be less than or equal to site suggestion = 50%"

    end

    it "should not add errors when drug_calculation is less than or iqual to site_suggestion" do
      @order_line_drug.site_suggestion = 60 
      @order_line_drug.quantity_suggested_drug?.should eq true
      @order_line_drug.errors.full_messages.size.should eq 0
    end
  end

  describe 'validate quantity_suggested with type kit ' do
    before(:each) do
      @order = FactoryGirl.create :order
      @order_line_kit = @order.order_lines.build( arv_type: CommodityCategory::TYPES_KIT,
                                                  site_suggestion: 50 , 
                                                  test_kit_waste_acceptable: 5, 
                                                  number_of_client: 20, 
                                                  consumption_per_client_per_month: 30,
                                                  stock_on_hand:  200,
                                                  monthly_use: 500
        )
    end

    it "should return for cal_kit" do
      @order_line_kit.cal_kit.should eq 20
    end

    it "should not add errors when stock_on_hand is blank" do
      @order_line_kit.stock_on_hand = ""
      @order_line_kit.quantity_suggested_kit?.should eq true
      @order_line_kit.errors.full_messages.size.should eq 0
    end

    it "should not add errors when monthly_use is blank" do
      @order_line_kit.monthly_use = ""
      @order_line_kit.quantity_suggested_kit?.should eq true
      @order_line_kit.errors.full_messages.size.should eq 0
    end

    it "should add errors when kit calculation is bigger than test_kit_waste_acceptable" do
      @order_line_kit.quantity_suggested_kit?.should eq false
      @order_line_kit.errors.full_messages[0].should eq "Stock on hand Invalid, Sstem calculation = 20% must be less than or equal to site wastage = 5%"
      @order_line_kit.errors.full_messages[1].should eq "Monthly use Invalid, Sstem calculation = 20% must be less than or equal to site wastage = 5%"
    end

    it  "should not add errors when kit calculation is less then or equal waste acceptable" do
      @order_line_kit.test_kit_waste_acceptable = 25
      @order_line_kit.quantity_suggested_kit?.should eq true
      @order_line_kit.errors.full_messages.size.should eq 0

    end

  end


end
