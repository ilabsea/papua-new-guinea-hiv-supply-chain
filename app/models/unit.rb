# == Schema Information
#
# Table name: units
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Unit < ActiveRecord::Base
  has_many :commodities
  has_many :regimen
  has_many :lab_tests

  attr_accessible :name
  validates :name, :presence => true
  validates :name, :uniqueness => true
end
