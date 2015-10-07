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
#  order_frequency                  :integer
#  site_id                          :integer
#  pack_size                        :float            default(1.0)
#  system_suggestion                :integer
#  suggestion_order                 :float
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
              system_suggestion: 100,
              site: @site,
              commodity: @commodity }

    @order_line = @order.order_lines.build(@attr)
  end

  describe '#cal_drug' do
    it "should return 83% of drug " do
      @order_line.cal_drug.should eq 83
    end
  end

  describe '#call_kit' do
    it 'should return of kit wastage' do
      @order_line.cal_kit.should eq 1100
    end
  end
end
