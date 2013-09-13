require 'spec_helper'

describe PublicHoliday do
  describe 'is_holiday' do
    before(:each) do
       FactoryGirl.create(:public_holiday, name: 'xxx', date: '2013-09-18')
       FactoryGirl.create(:public_holiday, name: 'yyy', date: '2013-09-19')
       FactoryGirl.create(:public_holiday, name: 'xxx', date: '2013-09-20')
    end

    it 'should return true if on saturday' do
    	date = '2013-09-07'
        holiday = PublicHoliday.is_holiday? date
        holiday.should eq true
    end

    it 'should return true if on sunday' do
    	date = Date.new 2013, 9, 8
    	holiday = PublicHoliday.is_holiday? date
    	holiday.should eq true
    end

    it 'should return true if date registered in public holiday list' do
    	['2013-09-18', Date.new(2013,9,19)].each do |date|
    		holiday = PublicHoliday.is_holiday? date
    		holiday.should eq true
    	end
    end

    it 'should return false if date is not on saturday, sunday nor registered in public holiday list' do
    	['2013-09-24', Date.new(2013,9,25)].each do |date|
    		holiday = PublicHoliday.is_holiday? date
    		holiday.should eq false
    	end
    end
 
  end

end