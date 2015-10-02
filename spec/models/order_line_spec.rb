# == Schema Information
#
# Table name: order_lines
#
#  id                               :integer          not null, primary key
#  order_id                         :integer
#  commodity_id                     :integer
#  stock_on_hand                    :integer
#  monthly_use                      :integer
#  earliest_expiry                  :datetime
#  quantity_system_calculation      :integer
#  quantity_suggested               :integer
#  user_data_entry_note             :text
#  user_reviewer_note               :text
#  status                           :string(255)
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  arv_type                         :string(255)
#  site_suggestion                  :integer
#  test_kit_waste_acceptable        :integer
#  number_of_client                 :integer
#  consumption_per_client_per_month :integer
#  is_set                           :boolean          default(FALSE)
#  shipment_status                  :boolean          default(FALSE)
#  completed_order                  :integer          default(0)
#  order_frequency                  :float
#  site_id                          :integer
#  pack_size                        :float            default(1.0)
#

require 'spec_helper'

describe OrderLine do
  before(:each) do
    @order = FactoryGirl.create :order
    @commodity = FactoryGirl.create(:commodity, :consumption_per_client_unit => 30)
    @site = FactoryGirl.create :site, suggestion_order: 50 , test_kit_waste_acceptable: 25, order_frequency: 2, order_start_at: (Time.now-1.month)

    @attr = { arv_type: CommodityCategory::TYPES_KIT,
              number_of_client: 20, 
              stock_on_hand:  200,
              monthly_use: 1200,
              quantity_suggested: 600,
              site: @site,
              commodity: @commodity }

    @order_line = @order.order_lines.build(@attr)
  end

  describe '#cal_drug' do
    it "should return 40% of drug " do
      @order_line.cal_drug.should eq 40
    end
  end

  describe '#call_kig' do
    it 'should return of kit wastage' do
      @order_line.cal_kit.should eq 20
    end
  end

  describe 'create order_line' do
    it 'should create successfull order_line' do
      @order_line.save.should eq true
    end

    it 'should require stock_on_hand to be a valid positive number' do
      ['xxx', -10, nil].each do |stock_on_hand|
        @order_line.stock_on_hand = stock_on_hand
        @order_line.save.should eq false
        @order_line.errors.full_messages[0].should =~ /Stock/
      end
    end  

    it 'should require quantity_suggested to be a valid positive number' do
      ['10xx', -10, 0].each do |quantity_suggested|
        @order_line.quantity_suggested = quantity_suggested
        @order_line.save.should eq false
        @order_line.errors.full_messages[0].should =~ /Quantity suggested/
      end
    end

    it 'should require monthly_use to be a valid number' do
      ['xxxc', -30, nil].each do |monthly_use|
        @order_line.monthly_use = monthly_use
        @order_line.save.should eq false
        @order_line.errors.full_messages[0].should =~ /Monthly use/
      end
    end

    it 'should require monthly_use if type is kit' do
      @order_line.monthly_use = nil
      @order_line.save.should eq false
      @order_line.errors.full_messages[0].should =~ /Monthly use/
    end

    it 'should not require monthly_use if type is drug' do
      @order_line.monthly_use = nil
      @order_line.arv_type = CommodityCategory::TYPES_DRUG
      @order_line.save.should eq true
      @order_line.errors.full_messages.size.should eq 0
    end

    it 'should allow [quantity_suggested, stock_on_hand] to be both nil in the same time for type drug' do
      @order_line.arv_type = CommodityCategory::TYPES_DRUG
      @order_line.quantity_suggested = nil
      @order_line.stock_on_hand = nil
      @order_line.save.should eq true
    end

    it 'should allow [quantity_suggested, stock_on_hand, monthly_use] to be all nil in the same time for type kit' do
      @order_line.quantity_suggested = nil
      @order_line.stock_on_hand = nil
      @order_line.monthly_use = nil
      @order_line.save.should eq true
    end
  end

end
