require 'spec_helper'

describe String do
  describe '#str_str' do

    it "should replace with hash" do
      template = 'Age: {age}, Name: {name}'
      values = {:age => 23, :name => 'Foo Bar'}
      template.str_tr(values).should == 'Age: 23, Name: Foo Bar'
    end

    it "should replace ?? if key is missing" do
      template = 'Age: {age}, Name: {name}'
      template.str_tr({}).should == 'Age: ??, Name: ??'
    end
  end

  describe "highlight search" do
    before(:each) do
      @string = "vatanak monkol borey srey sonthor"
    end

    it "should highlight the 'vatanak' " do
      str = @string.highlight_search("vatanak")
      str.should == "<span class='highlight'>vatanak</span> monkol borey srey sonthor"
    end

    it "should highlight the 'rey' string " do
      str = @string.highlight_search("rey")
      str.should == "vatanak monkol bo<span class='highlight'>rey</span> s<span class='highlight'>rey</span> sonthor"
    end

    it "should highlight the 'rey' string ignoring the case " do
      str = @string.highlight_search("Rey")
      str.should == "vatanak monkol bo<span class='highlight'>rey</span> s<span class='highlight'>rey</span> sonthor"
    end


    it "should return the same string when no key is found " do
      str = @string.highlight_search("no found")
      str.should == @string
    end  
  end

  describe '#without_sms_protocol' do
    it 'it should remove sms protocol from the number if it exists' do
      "sms://8597555546".without_sms_protocol.should eq '8597555546'
    end

    it 'should be the same if the value does not has sms protocol' do
      ['sms:/8597555546', '855975553553'].each do |value|
        value.without_sms_protocol.should eq value
      end
    end
  end

  describe '#with_sms_protocol' do
    it "should pretend sms:// infront of value" do
      "855975553553".with_sms_protocol.should eq "sms://855975553553"
    end
  end

  describe '#is_numeric?' do
    it "should return true for numerical string" do
      ["12.34","-9394.09","0103.0", "10"].map{|item| item.is_numeric?}.should eq [true, true, true, true]
    end

    it "should return false for non numerical string" do
      ["xx", "99.xx", "34x", "34.39x" ].map{|item| item.is_numeric?}.should eq [false, false, false, false]
    end

  end
end
