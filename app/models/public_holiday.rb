# == Schema Information
#
# Table name: public_holidays
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  date       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PublicHoliday < ActiveRecord::Base
  attr_accessible :date, :name
  validates :name, :date , :presence => true

  def self.is_holiday? entry_day
    day = entry_day.class == String ? Date.parse(entry_day) : entry_day
    return true if day.sunday? || day.saturday?
    public_holiday = find_by_date(day)
    public_holiday ? true : false
  end
end
