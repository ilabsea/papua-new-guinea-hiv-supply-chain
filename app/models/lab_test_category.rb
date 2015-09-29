class LabTestCategory < ActiveRecord::Base
  attr_accessible :name, :description
  validates :name, presence: true
  validates :name, uniqueness: true
end
