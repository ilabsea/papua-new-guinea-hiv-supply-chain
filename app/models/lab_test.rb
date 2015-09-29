class LabTest < ActiveRecord::Base
  belongs_to :lab_test_category
  belongs_to :unit

  attr_accessible :name, :lab_test_category_id, :unit_id

  validates :name, uniqueness: true
  validates :name, :lab_test_category_id, :unit_id, presence: true
end
