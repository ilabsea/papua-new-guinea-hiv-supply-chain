# == Schema Information
#
# Table name: lab_test_categories
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class LabTestCategory < ActiveRecord::Base
  attr_accessible :name, :description
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :lab_tests
end
