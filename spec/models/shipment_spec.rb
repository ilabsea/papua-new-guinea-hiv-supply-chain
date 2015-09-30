# == Schema Information
#
# Table name: shipments
#
#  id                   :integer          not null, primary key
#  consignment_number   :string(20)
#  status               :string(20)
#  shipment_date        :date
#  received_date        :datetime
#  user_id              :integer
#  site_id              :integer
#  order_id             :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  sms_logs_count       :integer          default(0)
#  shipment_lines_count :integer          default(0)
#  last_notified_date   :datetime
#  lost_date            :datetime         default(2015-09-30 03:11:51 UTC)
#  cost                 :float
#  carton               :integer
#  site_messages_count  :integer          default(0)
#

require 'spec_helper'

describe Shipment do
  before(:each) do
    @user = FactoryGirl.create :user
    @attr = {
      :status => Shipment::STATUS_IN_PROGRESS,
      :consignment_number => '0101929100',
      :shipment_date => Time.now,
      :user => @user,
      :cost => 201.29,
      :carton => 10
    }

  end

  describe '::create' do
    it "should create a shipment with valid attributes" do
      shipment = Shipment.new @attr
      expect{shipment.save}.to change{Shipment.count}.by(1)
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

    it 'should require cost to be a number' do
      shipment = Shipment.new @attr.merge(:cost  => 'xx' )
      shipment.save.should be_false
      shipment.errors.full_messages =~ ["Cost is not a valid number"]
    end

    it 'should require cost to be greater than or iqual to 0 value' do
      shipment = Shipment.new @attr.merge(:cost  => 0.0 )
      
      result = shipment.save
      result.should be_true
    end

    it 'should require consignment_number to be unique' do
      shipment1 = FactoryGirl.create :shipment
      shipment2 = FactoryGirl.create :shipment

      shipment2.consignment_number = shipment1.consignment_number
      shipment2.save.should be_false
      shipment2.errors.full_messages[0].should eq 'Consignment number has already been taken'

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

      shipments.should be_true
      
      shipment1 = Shipment.find @shipment1.id
      shipment2 = Shipment.find @shipment2.id


      shipment1.status.should eq Shipment::STATUS_LOST
      shipment1.status.should eq Shipment::STATUS_LOST

      shipment2.received_date.should be_nil
      shipment2.received_date.should be_nil

      unchanged_shipment.status.should eq @shipment3.status

    end
  end

  describe '#deadline_for?' do
    describe 'for type day' do
      before(:each) do
        @site = FactoryGirl.create(:site, :duration_type => Setting::DURATION_TYPE_DAY, :in_every => 3)
        @shipment = FactoryGirl.create(:shipment, :site => @site)  
      end

      it 'should return true if the shipment date plus in_every number of days has passed' do
        created_at = Time.new(2013,9,11)
        @shipment.stub!(:last_notified_date).and_return(created_at)
        current = Time.new(2013,9,15)
        deadline = @shipment.deadline_for? current
        deadline.should eq true
      end

      it 'should return false if the shipment date plus in_every number of days has not passed' do
        created_at = Time.new 2013,9,11
        @shipment.stub!(:last_notified_date).and_return(created_at)
        current = Time.new(2013,9,14)
        deadline = @shipment.deadline_for? current
        deadline.should eq false
      end
    end

    describe 'for type hour' do
      before(:each) do
        @site = FactoryGirl.create(:site, duration_type: Setting::DURATION_TYPE_HOUR, :in_every => 2)
        @shipment = FactoryGirl.create :shipment, site: @site
      end

      it 'should return true if shipment date plus in_every number of hours has passed' do
        created_at = Time.new(2013,9,10,8,10,0)
        @shipment.stub!(:last_notified_date).and_return(created_at)
        current    = Time.new(2013,9,11,11,10,10)
        deadline = @shipment.deadline_for? current
        deadline.should eq true
      end

      it 'should return false if shipment date plus in_every number of hours has not passed' do
        created_at = Time.new(2013,9,10,8,10,0)
        @shipment.stub!(:last_notified_date).and_return(created_at)
        current    = Time.new(2013,9,10,9,10,10)
        deadline = @shipment.deadline_for? current
        deadline.should eq false
      end
    end
  end

  describe '#alert_deadline' do
    it 'should alert_deadline' do
      Setting[:message_asking_site] = 'hi {site} Consignment: {consignment} date: {shipment_date}'

      Sms.should_receive(:send)

      @site = FactoryGirl.create :site, name: 'Kampongchame'
      @shipment = FactoryGirl.create :shipment, site: @site, shipment_date: Time.new(2013,9,9)

      expect{@shipment.alert_deadline}.to change{SmsLog.count}.by(1)

    end

  end


end