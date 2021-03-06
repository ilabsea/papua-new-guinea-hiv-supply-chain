require 'spec_helper'

describe OrderLineSuggestion do
  before(:each) do
    @site1 = FactoryGirl.create(:site, order_frequency: 3)
    @site2 = FactoryGirl.create(:site, order_frequency: 3)

    order1 = FactoryGirl.create(:order, site: @site1)
    order2 = FactoryGirl.create(:order, site: @site2)

    @commodity1 = FactoryGirl.create(:commodity, )
    @commodity2 = FactoryGirl.create(:commodity)
    @commodity3 = FactoryGirl.create(:commodity)


    FactoryGirl.create(:order_line, quantity_suggested: 10, site: @site1, commodity: @commodity1, created_at: 3.months.ago, order: order1)
    FactoryGirl.create(:order_line, quantity_suggested: 30, site: @site1, commodity: @commodity1, created_at: 2.months.ago, order: order1)
    FactoryGirl.create(:order_line, quantity_suggested: 50, site: @site1, commodity: @commodity1, created_at: 1.months.ago, order: order1)

    FactoryGirl.create(:order_line, quantity_suggested: 30, site: @site1, commodity: @commodity2, created_at: 2.months.ago, order: order1)
    FactoryGirl.create(:order_line, quantity_suggested: 50, site: @site1, commodity: @commodity2, created_at: 1.months.ago, order: order1)

    FactoryGirl.create(:order_line, quantity_suggested: 10, site: @site1, commodity: @commodity3, created_at: 2.months.ago, order: order1)



    @recent_order_line_with_old_history = FactoryGirl.create(:order_line,
                                                              site: @site1,
                                                              commodity:@commodity1,
                                                              order: order1,
                                                              order_frequency: @site1.order_frequency,
                                                              stock_on_hand: 10,
                                                              monthly_use: 30)

    @recent_order_line_with_out_history = FactoryGirl.create(:order_line,
                                                             site: @site2,
                                                             commodity: @commodity1,
                                                             order: order2,
                                                             order_frequency: @site2.order_frequency,
                                                             stock_on_hand: nil,
                                                             monthly_use: nil)

  end

  describe '#quantity_suggested_list' do
    it 'return average quantity_suggested along with site and commodity of orline of 3 month agos' do
      order_line_suggestion = OrderLineSuggestion.new
      quantity_suggested_list = order_line_suggestion.quantity_suggested_list

      expect(quantity_suggested_list[0].average).to eq (10+30+50)/3
      expect(quantity_suggested_list[0].commodity_id).to eq @commodity1.id
      expect(quantity_suggested_list[0].site_id).to eq @site1.id

      expect(quantity_suggested_list[1].average).to eq (30+50)/2
      expect(quantity_suggested_list[1].commodity_id).to eq @commodity2.id
      expect(quantity_suggested_list[1].site_id).to eq @site1.id

      expect(quantity_suggested_list[2].average).to eq 10
      expect(quantity_suggested_list[2].commodity_id).to eq @commodity3.id
      expect(quantity_suggested_list[2].site_id).to eq @site1.id
    end
  end

  describe '#average' do
    context 'orderline of the site and commodity that has historical data of 3 month agos' do
      it 'return average of the quantity_suggested of 3 month agos' do
        order_line_suggestion = OrderLineSuggestion.new
        average = order_line_suggestion.average(@recent_order_line_with_old_history)
        expect(average).to eq 30.0
      end
    end

    context 'order line that has no historical data' do
      it 'return nil for suggestion' do
        order_line_suggestion = OrderLineSuggestion.new
        average = order_line_suggestion.average(@recent_order_line_with_out_history)
        expect(average).to be_nil
      end
    end
  end

  describe '#suggested_value' do
    context 'average is not nil' do
      it 'return suggested value for the order_line based on average' do
        order_line_suggestion = OrderLineSuggestion.new
        order_line_suggestion.stub(:average).with(@recent_order_line_with_old_history).and_return(10)

        quantity_suggested = order_line_suggestion.suggested_value(@recent_order_line_with_old_history)
        expect(quantity_suggested).to eq (10 * 3) - 10
      end
    end

    context 'average is nil' do
      it 'return suggested value for the order_line base on monthly_use' do
        order_line_suggestion = OrderLineSuggestion.new
        order_line_suggestion.stub(:average).with(@recent_order_line_with_old_history).and_return(nil)
        quantity_suggested = order_line_suggestion.suggested_value(@recent_order_line_with_old_history)
        expect(quantity_suggested).to eq (30 * 3) - 10
      end
    end

    context 'monthly_use is nil' do
      it 'return monthly_use' do
        order_line_suggestion = OrderLineSuggestion.new
        order_line_suggestion.stub(:average).with(@recent_order_line_with_out_history).and_return(nil)
        quantity_suggested = order_line_suggestion.suggested_value(@recent_order_line_with_out_history)
        expect(quantity_suggested).to eq ( (0 * 3) - 0)
      end


    end
  end

end