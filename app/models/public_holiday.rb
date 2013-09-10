class PublicHoliday < ActiveRecord::Base
  attr_accessible :date, :name
  validates :name, :date , :presence   =>  true
  default_scope order('public_holidays.date ASC')
end
