# == Schema Information
#
# Table name: commodities
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  commodity_category_id :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  abbreviation          :string(255)
#  quantity_per_packg    :string(255)
#  pack_size             :float
#  regimen_id            :integer
#  lab_test_id           :integer
#  unit_id               :integer
#  strength_dosage       :string(255)
#

require 'spec_helper'

describe Commodity do
  describe "Create commodity" do
    before(:each) do
      @commodity_category = FactoryGirl.create :commodity_category
      unit =  FactoryGirl.create(:unit)
      lab_test = FactoryGirl.create(:lab_test)
      regimen = FactoryGirl.create(:regimen)
      @valid_attr = {
        name: 'Commodity1',
        commodity_category: @commodity_category,
        commodity_type: CommodityCategory::TYPES_KIT,
        pack_size: 1.0,
        unit_id: unit.id,
        lab_test_id: lab_test.id,
        regimen_id: regimen.id
      }
    end

    it "should create commodity with valid attribute successfully" do
       commodity = Commodity.new @valid_attr
       expect{commodity.save}.to change{Commodity.count}.by(1)
    end

    describe 'with invalid attribute' do
      it "should require strength_dosage, abbreviation, quantity_per_packg when commodity_type is drugs" do
        commodity = Commodity.new @valid_attr.merge(:commodity_type => CommodityCategory::TYPES_DRUG)
        commodity.save.should eq false
        commodity.errors.full_messages.size.should eq 3
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
