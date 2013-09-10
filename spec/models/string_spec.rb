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
  describe '#is_numeric?' do
    it "should return true for numerical string" do
      ["12.34","-9394.09","0103.0", "10"].map{|item| item.is_numeric?}.should eq [true, true, true, true]
    end

    it "should return false for non numerical string" do
      ["xx", "99.xx", "34x", "34.39x" ].map{|item| item.is_numeric?}.should eq [false, false, false, false]
    end

  end
end
