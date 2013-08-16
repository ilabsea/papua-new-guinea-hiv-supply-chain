require 'spec_helper'

describe Shipment do
  before(:each) do
  	@user = FactoryGirl.create :user
  	@attr = {
  		:status => Shipment::STATUS_IN_PROGRESS,
  		:consignment_number => '01019291',
  		:shipment_date => Time.now,
  		:user => @user
  	}

  end

  describe '::create' do
	it "should create a shipment with valid attributes" do
	  shipment = Shipment.new @attr
	  expect{shipment.save}.to change{Shipment.count}.by(1)
	end

  	it "should require consignment_number to be numeric" do
  	  shipment = Shipment.new @attr.merge(:consignment_number => '02817739x' )
  	  shipment.save.should be_false
  	  shipment.errors.full_messages.should =~ ["Consignment number is not a number"]
  	end	

  	it "should require shpment_date" do
  	  shipment = Shipment.new @attr.merge(:shipment_date => '')
  	  shipment.save.should be_false
  	  shipment.errors.full_messages =~ ["Shipment date can't be blank"]
  	end	

  	it "should require a user" do
	  shipment = Shipment.new @attr.merge(:user  => nil )
  	  shipment.save.should be_false
  	  shipment.errors.full_messages =~ ["User can't be blank"]
  	end 
  end

  describe '::bulk_update_status' do
  	before(:each) do
  	  @shipment1 = FactoryGirl.create :shipment
  	  @shipment2 = FactoryGirl.create :shipment
  	  @shipment3 = FactoryGirl.create :shipment

  	end

  	it "should update status of the shipment" do
  		ids = [@shipment1.id, @shipment2.id]
  		unchanged_shipment = Shipment.find(@shipment3.id)

  		status = Shipment::STATUS_LOST
  		shipments = Shipment.bulk_update_status(ids, status)

  		shipments.size.should eq 2
  		shipments[0].status.should eq Shipment::STATUS_LOST
  		shipments[1].status.should eq Shipment::STATUS_LOST

  		
  		unchanged_shipment.status.should eq @shipment3.status

  	end

  end


end	