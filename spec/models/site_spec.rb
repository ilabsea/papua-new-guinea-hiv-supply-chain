# == Schema Information
#
# Table name: sites
#
#  id                           :integer          not null, primary key
#  name                         :string(255)
#  service_type                 :string(255)
#  suggestion_order             :float
#  order_frequency              :float
#  number_of_deadline_sumission :integer
#  order_start_at               :date
#  test_kit_waste_acceptable    :float
#  address                      :text
#  contact_name                 :string(255)
#  mobile                       :string(255)
#  land_line_number             :string(255)
#  email                        :string(255)
#  province_id                  :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  in_every                     :integer
#  duration_type                :string(255)
#  sms_alerted                  :integer          default(0)
#  site_messages_count          :integer          default(0)
#  town                         :string(255)
#  region                       :string(255)
#  max_alert_deadline           :integer          default(3)
#

require 'spec_helper'

describe Site do
  before(:each) do
    @site = FactoryGirl.create :site, order_start_at: '2013-07-07', order_frequency: 1.5 , number_of_deadline_sumission: 3
    @user = FactoryGirl.create :user_site, site: @site

    @requisition = FactoryGirl.create :requisition_report, site: @site, user: @user
  end

  it 'should return date for deadline_date' do
    deadline = @site.deadline_date

    deadline.month.should eq 8
    deadline.year.should eq 2013
    deadline.day.should eq 25
  end

  describe '#alert_dead_line' do
    it 'should alert to site and inform_alert deadline' do
      Setting[:message_deadline] = 'Hi {site} dead line date is : {deadline_date}'
      site = FactoryGirl.create :site, order_start_at: '2013-07-07',
                                order_frequency: 0.5 ,
                                number_of_deadline_sumission: 3,
                                sms_alerted: 0

      Sms.instance.stub(:send)
      sms_count = SmsLog.count
      site.alert_dead_line
      SmsLog.count.should eq (sms_count + 1)
      site.sms_alerted.should eq 1
    end
  end

  describe ".alertable" do
    it "should return alertable sites" do
      site1 = FactoryGirl.create :site, sms_alerted: 3, max_alert_deadline: 3
      site2 = FactoryGirl.create :site, sms_alerted: 2, max_alert_deadline: 3
      site3 = FactoryGirl.create :site, sms_alerted: 1, max_alert_deadline: 1
      site4 = FactoryGirl.create :site, sms_alerted: 0, max_alert_deadline: 1
      sites = Site.alertable
      sites.should eq [site2, site4]
    end

  end

  describe '#deadline?' do
    it 'should return false for #deadline that has requisition_report' do
      time = DateTime.strptime('2013-07-16', '%Y-%m-%d')
      now  = DateTime.strptime('2013-09-15', '%Y-%m-%d')

      @requisition.created_at = time
      @requisition.save

      deadline = @site.deadline_for? now
      deadline.should eq false
    end

    it 'should also return false for #deadline that has passed the deadline time' do
      time = DateTime.strptime('2013-07-16', '%Y-%m-%d')
      now  = DateTime.strptime('2013-09-10', '%Y-%m-%d')

      @requisition.created_at = time
      @requisition.save

      deadline = @site.deadline_for? now
      deadline.should eq false
    end

    it 'should return true for #deadline that has no requisition_report' do
      time = DateTime.strptime('2013-09-20', '%Y-%m-%d')
      now  = DateTime.strptime('2013-09-15', '%Y-%m-%d')
      @requisition.created_at = time
      @requisition.save

      deadline = @site.deadline_for? now
      deadline.should eq true
    end
  end
end
