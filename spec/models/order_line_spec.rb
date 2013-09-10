require 'spec_helper'

describe OrderLine do
  before(:each) do
    @order = FactoryGirl.create :order
    @commodity = FactoryGirl.create(:commodity)
    @attr = { arv_type: CommodityCategory::TYPES_KIT,
              site_suggestion: 50 , 
              test_kit_waste_acceptable: 25, 
              number_of_client: 20, 
              consumption_per_client_per_month: 30,
              stock_on_hand:  200,
              monthly_use: 500,
              quantity_suggested: 240,
              commodity: @commodity }

    @order_line = @order.order_lines.build( @attr)
  end

  describe '#save' do
    it 'should save order_line with valid attribute' do
      result = @order_line.save
      result.should eq true
      @order_line.completed_order.should eq OrderLine::DATA_COMPLETE
      @order_line.quantity_system_calculation.should eq 400

    end
  end


  describe '#calculate_completed_order' do
    describe 'of type kit' do
      it "should return value :complete  when none of [number_of_client,consumption_per_client_per_month, stock_on_hand,quantity_suggested, monthly_use] is empty " do
        @order_line.calculate_completed_order
        @order_line.completed_order.should eq  OrderLine::DATA_COMPLETE
      end

      it "should return value :incomplete to be true when one of [number_of_client,consumption_per_client_per_month, stock_on_hand,quantity_suggested, monthly_use] is empty " do
        [{:number_of_client => nil},{:consumption_per_client_per_month => nil}, {:stock_on_hand => nil}, {:quantity_suggested => nil},{:monthly_use => nil}].each do |attr|

          attr = @attr.merge(attr)
          order_line = @order.order_lines.build attr
          order_line.calculate_completed_order
          order_line.completed_order.should eq OrderLine::DATA_INCOMPLETE
        end
      end
    end

    describe 'of type drug' do
      before(:each) do
        @drug_attr = @attr.merge(:arv_type => CommodityCategory::TYPES_DRUG)
      end
      it "should return value :complete when none of [number_of_client,consumption_per_client_per_month, stock_on_hand,quantity_suggested] is empty " do
        attr = @drug_attr.merge(:monthly_use => nil)
        order_line  = @order.order_lines.build attr

        order_line.calculate_completed_order
        order_line.completed_order.should eq OrderLine::DATA_COMPLETE
      end

      it "should return value :incomplete when one of [number_of_client,consumption_per_client_per_month, stock_on_hand,quantity_suggested] is empty " do
        [{:number_of_client => nil},{:consumption_per_client_per_month => nil}, {:stock_on_hand => nil}, {:quantity_suggested => nil}].each do |attr|
          attr = @drug_attr.merge(attr)
          order_line = @order.order_lines.build attr
          order_line.calculate_completed_order
          order_line.completed_order.should eq OrderLine::DATA_INCOMPLETE
        end
      end
    end
  end

  describe '#validate monthly_use' do
    it "should not have error when monthly use value is a valid numberic value  " do
      @order_line.valid?
      @order_line.errors[:monthly_use].size.should eq 0
    end

    it "should has error when monthly_use is not a valid numberic value" do
      @order_line.monthly_use = "xxx"
      @order_line.valid?  
      @order_line.errors[:monthly_use].size.should eq 1
    end

    it "should not require monthly_use when type is drug" do
      @order_line.arv_type = CommodityCategory::TYPES_DRUG
      @order_line.valid?
      @order_line.errors[:monthly_use].size.should eq 0
    end
  end

  describe '#validate_quantity_suggested' do

    describe 'of type drug ' do
    	before(:each) do
    		@order = FactoryGirl.create :order
        @commodity = FactoryGirl.create(:commodity)
        @order_line_drug = @order.order_lines.build arv_type: CommodityCategory::TYPES_DRUG,
                              site_suggestion: 50 , 
                              test_kit_waste_acceptable: 5, 
                              number_of_client: 20, 
                              consumption_per_client_per_month: 30,
                              stock_on_hand:  100,
                              quantity_suggested: 200,
                              commodity: @commodity
    	end

    	it "should return 60 for order_line cal_drug" do
        @order_line_drug.cal_drug.should eq 60
    	end
    end

    describe 'of type kit ' do
      before(:each) do
        @order = FactoryGirl.create :order
        @commodity = FactoryGirl.create(:commodity)
        @order_line_kit = @order.order_lines.build( arv_type: CommodityCategory::TYPES_KIT,
                                                    site_suggestion: 50 , 
                                                    test_kit_waste_acceptable: 5, 
                                                    number_of_client: 20, 
                                                    consumption_per_client_per_month: 30,
                                                    stock_on_hand:  200,
                                                    monthly_use: 500,
                                                    commodity: @commodity
          )
      end

      it "should return for cal_kit" do
        @order_line_kit.cal_kit.should eq 25
      end
    end
  end
end
