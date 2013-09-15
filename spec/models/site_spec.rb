require 'spec_helper'

describe Site do
  before(:each) do
  	@site = FactoryGirl.create :site, order_start_at: '2013-07-07', order_frequency: 2 , number_of_deadline_sumission: 3
  	@user = FactoryGirl.create :user_site, site: @site

  	@requisition = FactoryGirl.create :requisition_report, site: @site, user: @user
  end

  it 'should return date for deadline_date' do
  	deadline =  @site.deadline_date
  	deadline.month.should eq 9
  	deadline.year.should eq 2013
  	deadline.day.should eq 10
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