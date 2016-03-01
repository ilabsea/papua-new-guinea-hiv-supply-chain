# == Schema Information
#
# Table name: orders
#
#  id                    :integer          not null, primary key
#  site_id               :integer
#  is_requisition_form   :boolean
#  user_place_order_id   :integer
#  order_date            :date
#  user_data_entry_id    :integer
#  review_date           :datetime
#  review_user_id        :integer
#  status                :string(15)
#  requisition_report_id :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  date_submittion       :date
#  order_number          :string(10)
#

require 'spec_helper'

describe Order do
  describe 'Create Order' do
    before(:each) do
      @site  = FactoryGirl.create :site
      @user_site = FactoryGirl.create :user_site
      @user_data_entry = FactoryGirl.create :user_data_entry
      @valid  = {
         :site => @site ,
         :is_requisition_form =>false,
         :date_submittion => "25-06-2013 10:58:09",
         :user_place_order => @user_site,
         :order_date  => "25-06-2013 10:58:09",
         :user_data_entry => @user_data_entry,
         :review_date => "25-06-2013 10:58:09",
         :requisition_report => false,
         :status => Order::ORDER_STATUS_PENDING
      }
    end

    describe "with valid attribute" do
      it "should create order with valid attribute" do
        order = Order.new @valid
        expect{order.save}.to change{Order.count}.by(1)
      end
    end

    # describe 'with invalid attribute' do
    #   it 'should require site uniqueness with scope of year and month in date_order ' do
    #     old_order = Order.create @valid
    #     order = Order.new @valid
    #     expect{order.save}.to change{Order.count}.by(0)
    #     order.errors.full_messages.count.should eq 2
    #     order.errors.full_messages[0].should eq "Site #{old_order.site.name} has already had an order on 25-06-2013"
    #     order.errors.full_messages[1].should eq "Order date #{old_order.site.name} has already had an order on 25-06-2013"
    #   end
    # end

  end

  describe 'total_by_status' do
    it 'should return order by status correctly' do
      FactoryGirl.create :order, :status => Order::ORDER_STATUS_PENDING
      FactoryGirl.create :order, :status => Order::ORDER_STATUS_PENDING
      FactoryGirl.create :order, :status => Order::ORDER_STATUS_PENDING
      FactoryGirl.create :order, :status => Order::ORDER_STATUS_PENDING
      FactoryGirl.create :order, :status => Order::ORDER_STATUS_PENDING

      FactoryGirl.create :order, :status => Order::ORDER_STATUS_TO_BE_REVIEWED
      FactoryGirl.create :order, :status => Order::ORDER_STATUS_TO_BE_REVIEWED
      FactoryGirl.create :order, :status => Order::ORDER_STATUS_TO_BE_REVIEWED
      FactoryGirl.create :order, :status => Order::ORDER_STATUS_TO_BE_REVIEWED

      FactoryGirl.create :order, :status => Order::ORDER_STATUS_TO_BE_REVISED
      FactoryGirl.create :order, :status => Order::ORDER_STATUS_TO_BE_REVISED
      FactoryGirl.create :order, :status => Order::ORDER_STATUS_TO_BE_REVISED
      FactoryGirl.create :order, :status => Order::ORDER_STATUS_TO_BE_REVISED

      FactoryGirl.create :order, :status => Order::ORDER_STATUS_APPROVED

      total = Order.total_by_status

      total.should  eq({
        Order::ORDER_STATUS_PENDING => 5,
        Order::ORDER_STATUS_TO_BE_REVIEWED => 4,
        Order::ORDER_STATUS_TO_BE_REVISED  => 4,
        Order::ORDER_STATUS_APPROVED => 1
      })
    end
  end

  describe ".embed_total_shipped" do
    it 'return order with total_shipped' do
      order_pending  = FactoryGirl.create(:order, status: Order::ORDER_STATUS_PENDING)
      order_revised  = FactoryGirl.create(:order, status: Order::ORDER_STATUS_TO_BE_REVISED)

      order_approved1 = FactoryGirl.create(:order, status: Order::ORDER_STATUS_APPROVED)
      order_approved2 = FactoryGirl.create(:order, status: Order::ORDER_STATUS_APPROVED)

      FactoryGirl.create(:order_line, shipment_status: true, order: order_approved1)
      FactoryGirl.create(:order_line, shipment_status: true, order: order_approved2)
      FactoryGirl.create(:order_line, shipment_status: true, order: order_approved2)
      FactoryGirl.create(:order_line, shipment_status: true, order: order_approved1)
      FactoryGirl.create(:order_line, shipment_status: true, order: order_approved1)

      FactoryGirl.create(:order_line, shipment_status: false, order: order_approved1)
      FactoryGirl.create(:order_line, shipment_status: false, order: order_approved2)

      orderline = FactoryGirl.create(:order_line, shipment_status: true, order: order_approved1)

      orders = Order.embed_total_shipped
      expect_result_contains(orders[0], order_pending, nil)
      expect_result_contains(orders[1], order_revised, nil)
      expect_result_contains(orders[2], order_approved1, 4)
      expect_result_contains(orders[3], order_approved2, 2)

    end

    def expect_result_contains(order_result, order, total)
      expect(order_result).to eq order
      expect(order_result.total_shipped).to eq total
    end
  end
end
