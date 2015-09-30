require 'spec_helper'

describe ShipmentSession do
  before(:each) do
    @session_mock = {}
    @shipment_session = ShipmentSession.new @session_mock

  end

  it ".shipment should return empty hash by default " do
    @shipment_session.shipment.class.should eq Hash
    @shipment_session.shipment.should be_empty
  end

  it '.size should return the length of current shipment_line' do
    @shipment_session.size.should eq 0
    @shipment_session.size.should eq @shipment_session.shipment.size

  end

  describe '.add' do
    it "should aggregate to shipment session with shipment_line_session " do
      shipment_line_session1 = ShipmentLineSession.new :quantity => 10, :remark => "xxx", :order_line_id => 1
      shipment_line_session2 = ShipmentLineSession.new :quantity => 20, :remark => "xxx", :order_line_id => 2

      @shipment_session.add shipment_line_session1
      @shipment_session.add shipment_line_session2

      @shipment_session.size.should eq 2

      @shipment_session.shipment[1].should eq shipment_line_session1.data
      @shipment_session.shipment[2].should eq shipment_line_session2.data
    end

    it "should update shipment session with existing shipment_line_session" do
      shipment_line_session1 = ShipmentLineSession.new :quantity => 10, :remark => "xxx", :order_line_id => 1
      @shipment_session.add shipment_line_session1

      shipment_line_session2 = ShipmentLineSession.new :quantity => 30, :remark => "ppp", :order_line_id =>1
      @shipment_session.add shipment_line_session2

      @shipment_session.size.should eq 1    
      @shipment_session.shipment[1].should eq shipment_line_session2.data

    end
  end

  describe '.delete' do
    before(:each) do
      @shipment_line_session1 = ShipmentLineSession.new :quantity => 10, :remark => "xxx", :order_line_id => 1
      @shipment_line_session2 = ShipmentLineSession.new :quantity => 20, :remark => "yyy", :order_line_id => 2

      @shipment_session.add @shipment_line_session1
      @shipment_session.add @shipment_line_session2

    end

    it "should modify nothing if key does not exist" do
      @shipment_session.delete(3).should be_nil
      @shipment_session.size.should eq 2
    end

    it "should remove item from session " do
      @shipment_session.delete(2).should eq @shipment_line_session2.data
      @shipment_session.size.should eq 1
    end

  end


  
end