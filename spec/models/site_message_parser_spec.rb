require 'spec_helper'

describe SiteMessageParser do
  before(:each) do
    Setting[:site_message_invalid_consignment_number] = 'consignment_number does not exist: {original_message}'
    Setting[:site_message_invalid_sender] = 'you are not authorized to send this body: {original_message}'
    Setting[:site_message_invalid_status] = 'status is invalid: {original_message}'
    Setting[:site_message_success] = 'you have successfully reported: {original_message}'
    Setting[:site_message_error_syntax] = 'syntax error: {original_message}'
  end

  it '#translate_message' do

  	error_type = :site_message_xxx
  	options = {
  		:error_type => :site_message_xxx,
  		:from => '85512161616',
  		:status => Shipment::STATUS_RECEIVED,
  		:consignment_number => '102010',
  		:body => '102938448.y' 
  	}
  	site_message_parser = SiteMessageParser.new options
  	Setting[:site_message_xxx] = "phone:{phone_number} consignment:{consignment} status:{status} original_body:{original_message}"

  	translation = 'phone:85512161616 consignment:102010 status:Received original_body:102938448.y'
  	site_message_parser.translate_message.should eq translation
  	site_message_parser.options[:response_message].should eq translation
  end

  describe '#process' do
    before(:each) do
      @site = FactoryGirl.create :site, :mobile => '85597666666'
      @shipment = FactoryGirl.create :shipment, consignment_number: '202020', site: @site
    end

    it 'should create a site_message if successfully parsed ' do
      site_message_parser = SiteMessageParser.new from: 'sms://85597666666', body: '202020.y', guid: '1345678dfghjklvbmhjkl'
      
      count = SiteMessage.count
      site_message = site_message_parser.process
      SiteMessage.count.should eq count+1
    end

    it 'should also create a site_message even if it parses  with error' do
      site_message_parser = SiteMessageParser.new from: 'sms://85597666666', body: '202020.y.xx', guid: '1345678dfghjklvbmhjkl'
      
      count = SiteMessage.count
      site_message = site_message_parser.process
      SiteMessage.count.should eq count+1

    end

  end

  describe '#parse' do
    before(:each) do
      @site = FactoryGirl.create :site, :mobile => '85597666666'
      @shipment = FactoryGirl.create :shipment, consignment_number: '202020', site: @site
      
      # :consignment_number, :from, :guid, :body, :status, :site
    end

    it 'should parse the message with no error ' do
      
      site_message_parser = SiteMessageParser.new from: 'sms://85597666666', body: '202020.y'
      site_message_parser.parse 
      site_message_parser.options[:error].should eq SiteMessageParser::ERROR_OK
      site_message_parser.options[:error_type].should eq :site_message_success
      site_message_parser.options[:site].should eq @site
      site_message_parser.options[:status].should eq Shipment::STATUS_RECEIVED
      site_message_parser.options[:consignment_number].should eq '202020'
      site_message_parser.options[:body].should eq '202020.y'
      site_message_parser.options[:from].should eq "sms://85597666666"
      site_message_parser.options[:response_message].should eq 'you have successfully reported: 202020.y'
    end

    it 'should parse the message and set the error :site_message_error_syntax ' do
      
      site_message_parser = SiteMessageParser.new from: 'sms://85597666666', body: '202020'

      site_message_parser.parse
      site_message_parser.options.should eq ({:from=>"sms://85597666666", 
                                              :body=>"202020", 
                                              :error=> SiteMessageParser::ERROR_ERROR, 
                                              :error_type=>:site_message_error_syntax, 
                                              :response_message=>"syntax error: 202020"})
    end

    it 'should parse the message and set the error :site_message_invalid_consignment_number' do
      site_message_parser = SiteMessageParser.new from: 'sms://85597666666', body: '200000.y'
      site_message_parser.parse
      site_message_parser.options.should eq ({ :from=>"sms://85597666666", 
                                               :body=>"200000.y", 
                                               :error=> SiteMessageParser::ERROR_ERROR, 
                                               :error_type=>:site_message_invalid_consignment_number, 
                                               :response_message=>"consignment_number does not exist: 200000.y"})
    end

    it 'should parse the message and set error :site_message_invalid_sender' do

      site_message_parser = SiteMessageParser.new from: 'sms://855975555555', body: '202020.y'
      site_message_parser.parse
      site_message_parser.options.should eq ({ :from=>"sms://855975555555", 
                                               :body=>"202020.y", 
                                               :error=> SiteMessageParser::ERROR_ERROR, 
                                               :error_type=>:site_message_invalid_sender, 
                                               :response_message=>"you are not authorized to send this body: 202020.y"})
    end

    it 'should parse the message and set error :site_message_invalid_status' do

      site_message_parser = SiteMessageParser.new from: 'sms://85597666666', body: '202020.x'
      site_message_parser.parse
      site_message_parser.options.should eq({:from=>"sms://85597666666", 
                                             :body=>"202020.x", 
                                             :error=> SiteMessageParser::ERROR_ERROR, 
                                             :error_type=>:site_message_invalid_status, 
                                             :consignment_number=>"202020", 
                                             :site=> @site,
                                             :response_message=>"status is invalid: 202020.x"})
    end

  end

  describe '#validate_syntax?' do
    it 'should return true if meessage has consignment_number and status' do
      site_message_parser = SiteMessageParser.new({body: '201010.y'})
      result = site_message_parser.validate_syntax?
      result.should be_true
    end

    it 'should return false if message components are not composed of only consignment_number and status' do
      ['202020', 'ccccc'].each do |message|
        site_message_parser = SiteMessageParser.new body: message
        result = site_message_parser.validate_syntax?
        result.should eq false
        site_message_parser.options[:error].should eq SiteMessageParser::ERROR_ERROR
        site_message_parser.options[:error_type].should eq :site_message_error_syntax
      end
    end
  end

  describe '#validate_consignment_number?' do
    before(:each) do
      @site =  FactoryGirl.create :site, mobile: '855975553553'
      @shipment = FactoryGirl.create :shipment, :consignment_number => '201010', site: @site

    end

    it 'should return true and set consignment_number,site if consignment is exist and the phone_number is match to the mobile of site in which shipment is packed to' do
      site_message_parser = SiteMessageParser.new({from: 'sms://855975553553' })
      result = site_message_parser.validate_consignment_number? '201010'
      result.should be_true
      site_message_parser.options[:consignment_number].should eq '201010'
      site_message_parser.options[:site].should eq @site
    end 

    it 'should set error_type to :site_message_invalid_consignment_number if consignment_number does not exist' do
      site_message_parser = SiteMessageParser.new({from: 'sms://855975553553' })
      result = site_message_parser.validate_consignment_number? '202020'
      result.should be_false
      site_message_parser.options[:error].should eq SiteMessageParser::ERROR_ERROR
      site_message_parser.options[:error_type].should eq :site_message_invalid_consignment_number
    end

    it 'should set error_type to :site_message_invalid_sender if consignment_number exist but reporter used different phone' do
      site_message_parser = SiteMessageParser.new from: 'sms://85597000000'
      result = site_message_parser.validate_consignment_number? '201010'
      result.should eq false
      site_message_parser.options[:error].should eq SiteMessageParser::ERROR_ERROR
      site_message_parser.options[:error_type].should eq :site_message_invalid_sender
    end
  end

  describe '#validate_status?' do
    before(:each) do
      @site_message_parser = SiteMessageParser.new({})
    end

    it 'should return true and set status to Received for value [r, y, yes]' do
      ['r', 'Y', 'Yes'].each do |status|
        result = @site_message_parser.validate_status? status
        result.should eq true
        @site_message_parser.options[:status].should eq Shipment::STATUS_RECEIVED
      end
    end

    it 'should return true and set status to Lost for value [l, N, NO]' do
      ['l', 'N', 'NO'].each do |status|
        result = @site_message_parser.validate_status? status
        result.should eq true
        @site_message_parser.options[:status].should eq Shipment::STATUS_LOST
      end
    end

    it 'should return true and set status to Partially received for value [p, P]' do
      ['p', 'P'].each do |status|
        result = @site_message_parser.validate_status? status
        result.should eq true
        @site_message_parser.options[:status].should eq Shipment::STATUS_PARTIALLY_RECEIVED
      end
    end

    it 'should return false and set error for status for other value beside [r, yes, y, l, no, n,p]' do
      ['t','s'].each do |status|
        result = @site_message_parser.validate_status? status
        result.should eq false
        @site_message_parser.options[:status].should be_nil
        @site_message_parser.options[:error].should be_true
        @site_message_parser.options[:error_type].should eq :site_message_invalid_status
      end
    end


  end  

end