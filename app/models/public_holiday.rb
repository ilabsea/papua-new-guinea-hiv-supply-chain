class PublicHoliday < ActiveRecord::Base
  attr_accessible :date, :name
  validates :name, :date , :presence   =>  true
  default_scope order('public_holidays.date ASC')

  def self.is_holiday? day
  	if day.class == String
  	   day = Date.parse day		
  	end

  	return true if day.sunday? || day.saturday?
  	public_holiday = find_by_date(day)
  	public_holiday ? true : false
  end
end
