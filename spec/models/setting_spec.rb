# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  tip        :string(255)
#  value      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Setting do
  before(:each) do
    Setting[:hour] = 10
  end

  it "should create a setting if key does not exist" do
    Setting[:message] = "Blah"
    Setting.count.should eq 2
    Setting.last.name.should eq "message"
    Setting.last.value.should eq "Blah"
  end

  it "should update an existing setting if name exists" do
    Setting[:hour] = 12
    Setting.count.should eq 1
    Setting.first.name.should eq "hour"
    Setting.first.value.should eq "12"
  end

  describe "getting setting by name" do
    it "should return a setting if name exist" do
      setting = Setting.get_setting("hour")
      setting.class.should eq Setting
      setting.name.should eq "hour"
      setting.value.should eq "10"
    end

    it "should return nil if key does not exist " do
      setting = Setting.get_setting(:hours)
      setting.should eq nil
    end
  end
end
