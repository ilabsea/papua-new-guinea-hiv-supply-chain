class PublicHoliday < ActiveRecord::Base
  attr_accessible :date, :name

  validates :name, :date , :presence   =>  true
end
