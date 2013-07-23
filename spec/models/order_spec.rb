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
    	:date_submittion => "2013-06-25 10:58:09",
    	:user_place_order => @user_site,
    	:order_date  => "2013-06-25 10:58:09",
    	:user_data_entry => @user_data_entry,
    	:review_date => "2013-06-25 10:58:09",
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

  	describe 'with invalid attribute' do
  	  it 'should require site uniqueness with scope of year and month in date_order ' do
  	  	old_order = Order.create @valid
  	  	order = Order.new @valid
  	  	expect{order.save}.to change{Order.count}.by(0)
  	  	order.errors.full_messages.count.should eq 2
        order.errors.full_messages[0].should eq "Site #{old_order.site.name} has already had an order on #{old_order.order_date}"
        order.errors.full_messages[1].should eq "Order date #{old_order.site.name} has already had an order on #{old_order.order_date}"
  	  end

  	end

  end

end
