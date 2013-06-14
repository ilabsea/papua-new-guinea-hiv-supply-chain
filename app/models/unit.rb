class Unit < ActiveRecord::Base
  attr_accessible :name
  validates :name, :presence => true
  validates :name, :uniqueness => true
  has_many :commodities
end
