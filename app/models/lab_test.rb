# == Schema Information
#
# Table name: lab_tests
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  lab_test_category_id :integer
#  unit_id              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class LabTest < ActiveRecord::Base
  belongs_to :lab_test_category
  belongs_to :unit

  has_many :commodities

  attr_accessible :name, :lab_test_category_id, :unit_id

  validates :name, uniqueness: true
  validates :name, :lab_test_category_id, :unit_id, presence: true
end
