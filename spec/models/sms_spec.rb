require 'spec_helper'

describe Sms do
  it "should allow to set attribute" do
  	sms = Sms.new
  	sms.body = "Hello, you have received a message"
  	sms.from = "From msx"
  	sms.to   = "85589000"

  	sms.body.should eq  "Hello, you have received a message"
  	sms.from.should eq  "From msx"
  	sms.to.should 	eq  "85589000"
  end	


  it "should set attribute via contructor as arg" do
	@sms = Sms.new do |sms|
		sms.body = '-body'
		sms.from = '-from'
		sms.to   = '-to'
	end
	
	@sms.body.should eq '-body'
	@sms.from.should eq '-from'
	@sms.to.should 	 eq '-to'
  end

  describe "#send" do
  	before(:each) do
  	   @adaptor = NuntiumMessagingAdaptor.instance
  	   @from = 'from-'
  	   @to   = 'to-'
  	   @body = 'body-'
  	   # allow(@adaptor).to receive(:send).with(@from, @to, @body).and_return "message"

  	end
  	it "should use default attr if block not given" do
  		@adaptor.should_receive(:send).with(:from => "from--", :to => "to--", :body => "body--")
  		sms = Sms.new do |sms|
  			sms.body = 'body--'
  			sms.from = 'from--'
  			sms.to   = 'to--'
  		end
  		sms.send @adaptor	
  	end

  	it "should use block to override default attrs" do
  		@adaptor.should_receive(:send).with(:from => '--from', :to => '--to', :body => 'body--')
  		sms = Sms.new do |sms|
  			sms.body = 'body--'
  			sms.from = 'from--'
  			sms.to   = 'to--'
  			
  		end

  		sms.send @adaptor do |sms|
  		  sms.from = '--from'
  		  sms.to   = '--to'
  		end

  		sms.from.should eq '--from'
  		sms.to.should eq '--to'
  		sms.body.should eq 'body--'
  	end
  end	

  describe "::send" do
  	it "should be able to send sms right away" do
		adaptor = NuntiumMessagingAdaptor.instance

		adaptor.should_receive(:send).with(:from => 'xxfrom', :to => 'xxto', :body => 'xxbody')

		Sms.send adaptor do |sms|
			sms.from = "xxfrom"
			sms.to   = "xxto"
			sms.body = "xxbody"
		end

		Sms.from.should eq 'xxfrom'
		Sms.to.should eq 'xxto'
		Sms.body.should eq 'xxbody'

  	end
  end
end
