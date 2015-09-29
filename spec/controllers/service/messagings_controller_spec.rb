require 'spec_helper'
require 'supports/basic_auth_helper'

describe Service::MessagingsController do
  include BasicAuthHelper

  describe "POST 'nuntium'" do
 	before(:each) do
 	  @site = FactoryGirl.create :site, :mobile => '85597666666'
      @shipment = FactoryGirl.create :shipment, consignment_number: '2020202020', site: @site, status: Shipment::STATUS_IN_PROGRESS
      @attrs = {from: 'sms://85597666666', body: '2020202020 y', guid: '1345678dfghjklvbmhjkl' }
      Setting[:site_message_success] = 'you have successfully reported'
 	end

    it "should be successful with valid auth and params" do
      nuntium_config = NuntiumMessagingAdapter.instance.config

  	  user = nuntium_config['incoming_username']
      pwd  = nuntium_config['incoming_password']	

      basic_auth(user, pwd)

      post :nuntium, @attrs
      response.status.should eq 200
      response.body.should eq '{"to":"sms://85597666666","body":"you have successfully reported","from":"Health supply chain"}'  
    end

    it "should be failed with invalid auth" do
      basic_auth('nuntium', '1234567')
      post :nuntium, @attrs
      response.status.should eq 401
    end

  end
end