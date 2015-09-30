require 'spec_helper'

describe ShipmentLineSession do
  before(:each) do
    @order1 = FactoryGirl.create :order
    @order2 = FactoryGirl.create :order

    @order_line_11 = FactoryGirl.create :order_line, :order => @order1
    @order_line_12 = FactoryGirl.create :order_line, :order => @order1
    @order_line_13 = FactoryGirl.create :order_line, :order => @order1

    @order_line_21 = FactoryGirl.create :order_line, :order => @order2
    @order_line_22 = FactoryGirl.create :order_line, :order => @order2
    @order_line_23 = FactoryGirl.create :order_line, :order => @order2
    @order_line_24 = FactoryGirl.create :order_line, :order => @order2

    session_mock = {}
    @shipment_session = ShipmentSession.new session_mock

    @attr = {
      :quantity => 1000,
      :order_line_id => @order_line_11.id,
      :shipment_session => @shipment_session
    }
  end

  describe 'validate' do
      describe 'with error' do
      it "should require quantity to be numeric" do
        shipment_line_session = ShipmentLineSession.new  @attr.merge(:quantity => "xxx")
        shipment_line_session.valid?.should eq false
        shipment_line_session.errors.full_messages[0].should eq "Quantity is not a number"
      end
    

      it "should require order_line_id to be numeric" do
        shipment_line_session = ShipmentLineSession.new @attr.merge(:order_line_id => "yyy")
        shipment_line_session.valid?.should eq false
        shipment_line_session.errors.full_messages.should =~ ["Order line is not a number", "Order line invalid commodity order. Please try again"]
      end  

      it "should require order_line_id in the same order of shipment_session" do
        shipment_line_session1 = ShipmentLineSession.new(@attr)
        @shipment_session.add shipment_line_session1

        shipment_line_session2 = ShipmentLineSession.new(@attr.merge(:order_line_id => @order_line_24.id))
        shipment_line_session2.valid?.should be_false
        shipment_line_session2.errors.full_messages =~ ["Order line can not be added to shipment of different order"]
      end
      end
      
      describe 'with valid attribute' do
        it "should validate successfully with quantity and order_line_id as number" do
          shipment_line_session = ShipmentLineSession.new @attr
          shipment_line_session.valid?.should be_true
        end

        it "should be valide when it is added to session with the same order" do
          shipment_line_session1 = ShipmentLineSession.new @attr
          @shipment_session.add shipment_line_session1

          shipment_line_session2 = ShipmentLineSession.new @attr.merge(:order_line_id => @order_line_12.id)
          shipment_line_session2.valid?.should be_true
        end
      end  

  end
end