require 'spec_helper'

describe Commodity do
  describe "Create commodity" do
  	before(:each) do
      @commodity_category = FactoryGirl.create :commodity_category
      @valid_attr = {
      	  name: 'Commodity1',
      	  commodity_category: @commodity_category,
      	  commodity_type: CommodityCategory::TYPES_KIT,
      	  consumption_per_client_pack: 1, 
      	  consumption_per_client_unit: 1,
      	  unit_id: 1
      }
  	end

  	it "should create commodity with valid attribute successfully" do
  	   commodity = Commodity.new @valid_attr
  	   expect{commodity.save}.to change{Commodity.count}.by(1)
  	end

  	describe 'with invalid attribute' do
  	  it "should require strength_dosage, abbreviation, quantity_per_packg when commodity_type is drugs  " do
  	  	commodity = Commodity.new @valid_attr.merge(:commodity_type => CommodityCategory::TYPES_DRUG)
  	  	commodity.save.should eq false
  	  	commodity.errors.full_messages.size.should eq 3
  	  end	

  	  it "should require consumption_per_client_pack to be numberical value" do
  	  	commodity = Commodity.new @valid_attr.merge(:consumption_per_client_pack => 'xxx')
  	  	commodity.save.should eq false
  	  	commodity.errors.full_messages[0].should eq 'Consumption per client pack is not a number'
  	  end

  	  it "should require consumption_per_client_unit to be numberical value" do
  	  	commodity = Commodity.new @valid_attr.merge(:consumption_per_client_unit => 'xxx')
  	  	commodity.save.should eq false
  	  	commodity.errors.full_messages[0].should eq 'Consumption per client unit is not a number'
  	  end

  	  it "should require name" do
  	  	commodity = Commodity.new @valid_attr.merge(:name => nil)
  	  	commodity.save.should eq false
  	  	commodity.errors.full_messages[0].should eq "Name can't be blank"
  	  end

  	  it "should require unit" do
  	  	commodity = Commodity.new @valid_attr.merge(:unit_id => nil)
  	  	commodity.save.should eq false
  	  	commodity.errors.full_messages[0].should eq "Unit can't be blank"
  	  end

  	  it "should require commodity category" do
  	  	commodity = Commodity.new @valid_attr.merge(:commodity_category => nil)
  	  	commodity.save.should eq false
  	  	commodity.errors.full_messages[0].should eq "Commodity category can't be blank"
  	  end
  	end
  end	

end