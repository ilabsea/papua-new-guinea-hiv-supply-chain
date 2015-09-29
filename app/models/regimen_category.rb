class RegimenCategory < ActiveRecord::Base
  attr_accessible :description, :name
  validates :name, uniqueness: true
  validates :name, presence: true
end
